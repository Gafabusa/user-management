using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using UserForms;
using UserForms.userAPI;
using System.Security.Cryptography;
using System.Text;

namespace UserForms.Admin.Users
{
    public partial class CreateUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoles();
                // Set up the master page for dashboard
                var master = (SiteMaster)this.Master;
                // Show landing page by default
                pnlLanding.Visible = true;
                pnlCreateUserForm.Visible = false;
            }
        }

        protected void btnShowCreateUserForm_Click(object sender, EventArgs e)
        {
            // Hide landing page and show form
            pnlLanding.Visible = false;
            pnlCreateUserForm.Visible = true;

            // Set focus to the first input field
            SetFocusOnLoad();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string fullName = txtFullName.Text.Trim();
                    string email = txtEmail.Text.Trim();
                    string phoneNumber = txtPhoneNumber.Text.Trim();

                    // Validate input
                    if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(phoneNumber))
                    {
                        ShowAlert("Please fill in all required fields.", "danger");
                        return;
                    }

                    // 1. Generate system password
                    string plainPassword = GenerateRandomPassword();

                    // 2. Hash password
                    string hashedPassword = HashPassword(plainPassword);

                    // 3. Call API to create user
                    var api = new userAPI.UserAPI();
                    int roleId = 2; // Change this if roles are selectable
                    int createdByUserId = 1; // Replace with logged-in admin's ID

                    var result = api.CreateUser(fullName, email, hashedPassword, roleId, createdByUserId);

                    // 4. Send email
                    SendUserWelcomeEmail(email, fullName, plainPassword);

                    // 5. Show success
                    ShowAlert("User created and email sent successfully!", "success");
                    ClearForm();
                    pnlLanding.Visible = true;
                    pnlCreateUserForm.Visible = false;
                }
                catch (Exception ex)
                {
                    ShowAlert("An error occurred: " + ex.Message, "danger");
                }
            }
        }


        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Go back to landing page
            pnlLanding.Visible = true;
            pnlCreateUserForm.Visible = false;
            ClearForm();
        }
        private void LoadRoles()
        {
            var api = new userAPI.UserAPI();
            DataTable dt = api.GetAllRoles();

            ddlRole.DataSource = dt;
            ddlRole.DataTextField = "RoleName";
            ddlRole.DataValueField = "RoleId";
            ddlRole.DataBind();

            ddlRole.Items.Insert(0, new ListItem("-- Select Role --", ""));
        }
        //generate random password
        private string GenerateRandomPassword()
        {
            // Generate a simple random password
            return Guid.NewGuid().ToString("N").Substring(0, 8);
        }
        //hashing password using SHA256
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }

        protected void lnkBackToDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/Dashboard.aspx");
        }

        private void ShowAlert(string message, string alertType)
        {
            lblMessage.Text = message;
            pnlAlert.CssClass = $"alert alert-{alertType} alert-dismissible fade show mb-3";
            pnlAlert.Visible = true;

            // Scroll to top to show the alert
            ScrollToTop();
        }

        private void ClearForm()
        {
            txtFullName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPhoneNumber.Text = string.Empty;
            pnlAlert.Visible = false;
        }

        private void SetFocusOnLoad()
        {
            // Set focus to the full name field using JavaScript
            string script = "document.getElementById('" + txtFullName.ClientID + "').focus();";
            ClientScript.RegisterStartupScript(this.GetType(), "SetFocus", script, true);
        }

        private void ScrollToTop()
        {
            // Scroll to top of page to show alert
            string script = "window.scrollTo(0, 0);";
            ClientScript.RegisterStartupScript(this.GetType(), "ScrollToTop", script, true);
        }
        private void SendUserWelcomeEmail(string toEmail, string fullName, string plainPassword)
        {
            string subject = "Welcome to the System";
            string body = $@"
        Hello {fullName},<br/><br/>
        Your user account has been created.<br/>
        <strong>Login Email:</strong> {toEmail}<br/>
        <strong>Temporary Password:</strong> {plainPassword}<br/><br/>
        Please log in and change your password immediately.<br/><br/>
        Regards,<br/>
        Admin Team
    ";

            try
            {
                System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
                mail.To.Add(toEmail);
                mail.Subject = subject;
                mail.Body = body;
                mail.IsBodyHtml = true;
                mail.From = new System.Net.Mail.MailAddress("youremail@example.com");

                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.Host = "smtp.yourserver.com"; 
                smtp.Port = 587; 
                smtp.Credentials = new System.Net.NetworkCredential("youremail@example.com", "yourpassword"); 
                smtp.EnableSsl = true;

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to send email: " + ex.Message, "danger");
            }
        }

    }
}
