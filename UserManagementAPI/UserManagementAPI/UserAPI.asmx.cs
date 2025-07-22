using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using UserClassLibrary.ControlObjects;

namespace UserManagementAPI
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    public class UserAPI : WebService
    {
        private readonly BusinessLogic businessLogic;
        public UserAPI()
        {
            businessLogic = new BusinessLogic();
        }
        //authenticate admin
        [WebMethod]
        public DataTable AdminLogin(string email, string password)
        {
            return businessLogic.AdminLogin(email, password);
        }
        //create user
        [WebMethod]
        public DataTable CreateUser(string fullName, string email, string hashedPassword, int roleId, int createdByUserId)
        {
            return businessLogic.CreateUser(fullName, email, hashedPassword, roleId, createdByUserId);
        }
        //get all roles
        [WebMethod]
        public DataTable GetAllRoles()
        {
            return businessLogic.GetAllRoles();
        }

        //change password
        [WebMethod]
        public void ChangePassword(int userId, string newHashedPassword)
        {
           businessLogic.ChangePassword(userId,newHashedPassword);
        }


    }
}
