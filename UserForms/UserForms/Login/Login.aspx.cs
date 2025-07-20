using System;
using System.Data;
using System.Web.Services.Protocols;
using System.Web.UI;

namespace UserForms.Login
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear any existing messages
                pnlAlert.Visible = false;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text;

                // Call the API
                var api = new userAPI.UserAPI();
                {
                    DataTable dt = api.AdminLogin(email, password);
                    if (dt.Rows.Count > 0)
                    {
                        Session["UserId"] = dt.Rows[0]["UserId"];
                        Session["FullName"] = dt.Rows[0]["FullName"];
                        Session["Email"] = dt.Rows[0]["Email"];
                        Session["RoleId"] = dt.Rows[0]["RoleId"];

                        Response.Redirect("~/Admin/Dashboard.aspx"); 
                    }
                    else
                    {
                        ShowMessage("Invalid email or password. Please try again.");
                    }
                }
            }
            catch (SoapException soapEx)
            {
                ShowMessage("A server error occurred: " + soapEx.Message);
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred during login: " + ex.Message);
            }
        }
        protected void lnkForgotPassword_Click(object sender, EventArgs e)
        {
            Response.Redirect("ForgotPassword.aspx");
        }

        private void ShowMessage(string message, string alertClass = "alert-danger")
        {
            lblMessage.Text = message;
            pnlAlert.CssClass = $"alert {alertClass} alert-dismissible fade show mb-3";
            pnlAlert.Visible = true;
        }
    }
}
