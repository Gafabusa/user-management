using System;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using UserForms.userAPI;

namespace UserForms.Login
{
    public partial class ChangePassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["PendingPasswordChangeUserId"] == null)
            {
                // Not authorized
                Response.Redirect("~/Login.aspx");
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string newPassword = txtNewPassword.Text;
                    string confirmPassword = txtConfirmPassword.Text;

                    if (newPassword != confirmPassword)
                    {
                        ShowAlert("Passwords do not match.", "danger");
                        return;
                    }

                    int userId = Convert.ToInt32(Session["PendingPasswordChangeUserId"]);

                    string hashedPassword = HashPassword(newPassword);

                    var api = new userAPI.UserAPI();
                    api.ChangePassword(userId, hashedPassword); // API method to call stored proc

                    // Clear session and redirect
                    Session.Remove("PendingPasswordChangeUserId");
                    Response.Redirect("~/Login.aspx?message=PasswordChanged");
                }
                catch (Exception ex)
                {
                    ShowAlert("An error occurred: " + ex.Message, "danger");
                }
            }
        }

        private void ShowAlert(string message, string type)
        {
            pnlAlert.CssClass = $"alert alert-{type} alert-dismissible fade show";
            lblMessage.Text = message;
            pnlAlert.Visible = true;
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(password);
                byte[] hash = sha.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }
    }
}
