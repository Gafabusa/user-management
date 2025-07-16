using System;
using System.Web.UI;

namespace schoolfeesportal.Login
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlAlert.Visible = false;
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim();             

                // TODO: Implement password reset logic
                ShowMessage("Password reset functionality to be implemented", "alert-info");
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred: " + ex.Message, "alert-danger");
            }
        }

        protected void lnkBackToLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        private void ShowMessage(string message, string alertClass = "alert-danger")
        {
            lblMessage.Text = message;
            pnlAlert.CssClass = $"alert {alertClass} alert-dismissible fade show mb-3";
            pnlAlert.Visible = true;
        }
    }
}
