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

    }
}
