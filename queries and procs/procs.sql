CREATE PROCEDURE sp_CreateUser
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @HashedPassword NVARCHAR(256), -- This will be generated and hashed in your backend
    @RoleId INT,
    @CreatedByUserId INT -- Admin who is creating the user
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Check if user with the same email already exists
    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        RAISERROR('A user with this email already exists.', 16, 1);
        RETURN;
    END

    -- 2. Insert new user
    INSERT INTO Users (
        FullName,
        Email,
        HashedPassword,
        RoleId,
        IsLocked,
        FailedLoginAttempts,
        IsFirstLogin,
        CreatedAt
    )
    VALUES (
        @FullName,
        @Email,
        @HashedPassword,
        @RoleId,
        0,              -- IsLocked = false
        0,              -- FailedLoginAttempts
        1,              -- IsFirstLogin = true
        GETDATE()
    );

    -- 3. Get the newly created UserId
    DECLARE @NewUserId INT = SCOPE_IDENTITY();

    -- 4. Log the action to AuditTrail
    INSERT INTO AuditTrail (
        UserId,
        Action,
        IPAddress,
        Device
    )
    VALUES (
        @CreatedByUserId,
        CONCAT('Created user account for ', @Email),
        NULL, -- Optionally pass IP from your application
        NULL  -- Optionally pass device info
    );

    -- Optionally return new user's ID if needed
    SELECT @NewUserId AS NewUserId;
END;


CREATE PROCEDURE sp_AuthenticateUser
    @Email NVARCHAR(100),
    @HashedPassword NVARCHAR(256),
    @IPAddress NVARCHAR(50) = NULL,
    @Device NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId INT, @RoleId INT, @IsLocked BIT, @StoredPassword NVARCHAR(256),
            @IsFirstLogin BIT, @FailedAttempts INT;

    -- 1. Check if user exists
    IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        SELECT 'InvalidCredentials' AS Status;
        RETURN;
    END

    -- 2. Get user details
    SELECT 
        @UserId = UserId,
        @StoredPassword = HashedPassword,
        @IsLocked = IsLocked,
        @RoleId = RoleId,
        @IsFirstLogin = IsFirstLogin,
        @FailedAttempts = FailedLoginAttempts
    FROM Users
    WHERE Email = @Email;

    -- 3. Check if account is locked
    IF @IsLocked = 1
    BEGIN
        SELECT 'AccountLocked' AS Status;
        RETURN;
    END

    -- 4. Check password
    IF @HashedPassword = @StoredPassword
    BEGIN
        -- Correct password

        -- Reset failed attempts
        UPDATE Users
        SET FailedLoginAttempts = 0
        WHERE UserId = @UserId;

        -- Log successful login
        INSERT INTO AuditTrail (UserId, Action, IPAddress, Device)
        VALUES (@UserId, 'Successful login', @IPAddress, @Device);

        -- Return success with user info
        SELECT 'Success' AS Status, @UserId AS UserId, @RoleId AS RoleId, @IsFirstLogin AS IsFirstLogin;
    END
    ELSE
    BEGIN
        -- Wrong password

        -- Increment attempts
        SET @FailedAttempts = @FailedAttempts + 1;

        UPDATE Users
        SET FailedLoginAttempts = @FailedAttempts,
            IsLocked = CASE WHEN @FailedAttempts >= 3 THEN 1 ELSE 0 END
        WHERE UserId = @UserId;

        -- Log failure
        INSERT INTO AuditTrail (UserId, Action, IPAddress, Device)
        VALUES (@UserId, 'Failed login attempt', @IPAddress, @Device);

        -- Return result
        IF @FailedAttempts >= 3
            SELECT 'AccountLocked' AS Status;
        ELSE
            SELECT 'InvalidCredentials' AS Status;
    END
END;


CREATE PROCEDURE sp_GenerateOtp
    @UserId INT,
    @OtpCode NVARCHAR(6),
    @ExpiryTime DATETIME,
    @IPAddress NVARCHAR(50) = NULL,
    @Device NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Insert OTP record
    INSERT INTO OTP (UserId, OtpCode, ExpiryTime, IsUsed, CreatedAt)
    VALUES (@UserId, @OtpCode, @ExpiryTime, 0, GETDATE());

    -- 2. Log action
    INSERT INTO AuditTrail (UserId, Action, IPAddress, Device)
    VALUES (@UserId, CONCAT('Generated OTP: ', @OtpCode), @IPAddress, @Device);

    -- 3. Optionally return success status
    SELECT 'OtpGenerated' AS Status;
END;


CREATE PROCEDURE sp_ValidateOtp
    @UserId INT,
    @EnteredOtp NVARCHAR(6),
    @IPAddress NVARCHAR(50) = NULL,
    @Device NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OtpId INT;

    -- 1. Check if there is a matching unused and unexpired OTP
    SELECT TOP 1 @OtpId = OtpId
    FROM OTP
    WHERE 
        UserId = @UserId AND 
        OtpCode = @EnteredOtp AND 
        IsUsed = 0 AND 
        ExpiryTime >= GETDATE()
    ORDER BY CreatedAt DESC;

    IF @OtpId IS NOT NULL
    BEGIN
        -- 2. Mark OTP as used
        UPDATE OTP
        SET IsUsed = 1
        WHERE OtpId = @OtpId;

        -- 3. Log success
        INSERT INTO AuditTrail (UserId, Action, IPAddress, Device)
        VALUES (@UserId, 'OTP validated successfully', @IPAddress, @Device);

        -- 4. Return success
        SELECT 'OtpValid' AS Status;
    END
    ELSE
    BEGIN
        -- 5. Log failure
        INSERT INTO AuditTrail (UserId, Action, IPAddress, Device)
        VALUES (@UserId, 'Invalid or expired OTP attempt', @IPAddress, @Device);

        -- 6. Return failure
        SELECT 'OtpInvalidOrExpired' AS Status;
    END
END;


CREATE PROCEDURE sp_UpdatePassword
    @UserId INT,
    @NewHashedPassword NVARCHAR(256),
    @IPAddress NVARCHAR(50) = NULL,
    @Device NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Check for password reuse
    IF EXISTS (
        SELECT 1 FROM PasswordHistory
        WHERE UserId = @UserId AND HashedPassword = @NewHashedPassword
    )
    BEGIN
        SELECT 'PasswordReuseNotAllowed' AS Status;
        RETURN;
    END

    DECLARE @OldHashedPassword NVARCHAR(256);

    -- 2. Get current password to store in history
    SELECT @OldHashedPassword = HashedPassword
    FROM Users
    WHERE UserId = @UserId;

    -- 3. Add old password to history
    INSERT INTO PasswordHistory (UserId, HashedPassword, ChangedAt)
    VALUES (@UserId, @OldHashedPassword, GETDATE());

    -- 4. Update user password and IsFirstLogin flag
    UPDATE Users
    SET 
        HashedPassword = @NewHashedPassword,
        IsFirstLogin = 0,
        UpdatedAt = GETDATE()
    WHERE UserId = @UserId;

    -- 5. Log password change
    INSERT INTO AuditTrail (UserId, Action, IPAddress, Device)
    VALUES (@UserId, 'Password changed successfully', @IPAddress, @Device);

    -- 6. Return success
    SELECT 'PasswordUpdated' AS Status;
END;


CREATE PROCEDURE sp_UnlockUser
    @TargetUserId INT,
    @AdminUserId INT,
    @IPAddress NVARCHAR(50) = NULL,
    @Device NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Unlock the user account and reset failed attempts
    UPDATE Users
    SET 
        IsLocked = 0,
        FailedLoginAttempts = 0,
        UpdatedAt = GETDATE()
    WHERE UserId = @TargetUserId;

    -- 2. Log the unlock action
    INSERT INTO AuditTrail (UserId, Action, IPAddress, Device)
    VALUES (
        @AdminUserId,
        CONCAT('Unlocked user account with ID: ', @TargetUserId),
        @IPAddress,
        @Device
    );

    -- 3. Return success status
    SELECT 'UserUnlocked' AS Status;
END;



CREATE PROCEDURE sp_LogAudit
    @UserId INT,
    @Action NVARCHAR(255),
    @IPAddress NVARCHAR(50) = NULL,
    @Device NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AuditTrail (
        UserId,
        Action,
        IPAddress,
        Device,
        ActionTime
    )
    VALUES (
        @UserId,
        @Action,
        @IPAddress,
        @Device,
        GETDATE()
    );
END;
