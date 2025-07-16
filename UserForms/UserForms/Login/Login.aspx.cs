using System;
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
                // Add your login logic here
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text;

                // TODO: Implement authentication logic
                // For now, just show a placeholder message
                ShowMessage("Login functionality to be implemented", "alert-info");
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred during login: " + ex.Message, "alert-danger");
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
