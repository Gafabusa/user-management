CREATE DATABASE UserManagement

use UserManagement

CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),

    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,

    HashedPassword NVARCHAR(256) NOT NULL, -- Will store the hashed version of the system-generated password

    RoleId INT NOT NULL, -- Foreign key to the Roles table

    IsLocked BIT DEFAULT 0, -- 0 = not locked, 1 = locked
    FailedLoginAttempts INT DEFAULT 0, -- Count of failed login attempts

    IsFirstLogin BIT DEFAULT 1, -- 1 = must change password on first login
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);


CREATE TABLE Roles (
    RoleId INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO Roles (RoleName)
VALUES ('Admin'),('HR'),('Manager'),('Chief Cleaner'),('Sales Manager');

CREATE TABLE OTP (
    OtpId INT PRIMARY KEY IDENTITY(1,1),

    UserId INT NOT NULL,
    OtpCode NVARCHAR(6) NOT NULL, -- 6-digit OTP
    ExpiryTime DATETIME NOT NULL, -- OTP validity duration
    IsUsed BIT DEFAULT 0, -- 0 = not used, 1 = used

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE AuditTrail (
    AuditId INT PRIMARY KEY IDENTITY(1,1),

    UserId INT NOT NULL,
    Action NVARCHAR(255) NOT NULL, -- e.g., "User login", "Changed password", "Account locked"
    IPAddress NVARCHAR(50) NULL,   -- Optional: capture client IP
    Device NVARCHAR(100) NULL,     -- Optional: capture device or browser info
    ActionTime DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);


CREATE TABLE PasswordHistory (
    HistoryId INT PRIMARY KEY IDENTITY(1,1),

    UserId INT NOT NULL,
    HashedPassword NVARCHAR(256) NOT NULL, -- Previous hashed password
    ChangedAt DATETIME DEFAULT GETDATE(), -- When it was changed

    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
