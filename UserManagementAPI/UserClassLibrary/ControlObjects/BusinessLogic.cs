using System;
using System.Data;


namespace UserClassLibrary.ControlObjects
{
    public class BusinessLogic
    {
        private readonly DatabaseHelper dbHelper;

        public BusinessLogic()
        {
            dbHelper = new DatabaseHelper();
        }
        //authenticate admin
        public DataTable AdminLogin(string email, string password)
        {
            object[] parameters = { email, password };
            return dbHelper.ExecuteDataTable("sp_AdminLogin", parameters);
        }
        //create user
        public DataTable CreateUser(string fullName, string email, string hashedPassword, int roleId, int createdByUserId)
        {
            object[] parameters = { fullName, email, hashedPassword, roleId, createdByUserId };
            return dbHelper.ExecuteDataTable("sp_CreateUser", parameters);
        }
        //get all roles
        public DataTable GetAllRoles()
        {
            return dbHelper.ExecuteDataTable("sp_GetAllRoles");
        }

        //change password
        public void ChangePassword(int userId, string newHashedPassword)
        {
            object[] parameters = { userId, newHashedPassword };
            dbHelper.ExecuteNonQuery("sp_ChangePassword", parameters);

        }
    }
}
