//using System;
//using System.Data;
//using System.Linq;
//using System.Net;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//namespace UserForms.Admin.Users
//{
//    public partial class UserManagement : System.Web.UI.Page
//    {
//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                LoadVendors();
//                pnlLanding.Visible = true;
//            }
//        }
//        private void LoadVendors()
//        {
//            try
//            {
//                var api = new schoolfeesapi.schoolfeesapi();
//                DataTable dt = api.GetAllVendors();
//                gvVendors.DataSource = dt;
//                gvVendors.DataBind();
//            }
//            catch (Exception ex)
//            {
//                ShowAlert("Failed to load vendors: " + ex.Message, "danger");
//            }
//        }

//        protected void btnSave_Click(object sender, EventArgs e)
//        {
//            if (Page.IsValid)
//            {
//                try
//                {
//                    var api = new schoolfeesapi.schoolfeesapi();
//                    bool isEditMode = !string.IsNullOrEmpty(hfEditingVendorId.Value);

//                    if (isEditMode)
//                    {
//                        // Update existing vendor
//                        int vendorId = Convert.ToInt32(hfEditingVendorId.Value);
//                        int updatedByUserId = Convert.ToInt32(Session["UserId"] ?? "1");
//                        string ipAddress = GetClientIPAddress();

//                        api.UpdateVendor(
//                            vendorId,
//                            txtVendorName.Text.Trim(),
//                            txtEmail.Text.Trim(),
//                            txtPhoneNumber.Text.Trim(),
//                            txtPassword.Text,
//                            Convert.ToBoolean(ddlIsApproved.SelectedValue),
//                            Convert.ToBoolean(ddlIsActive.SelectedValue),
//                            updatedByUserId,
//                            ipAddress
//                        );

//                        ShowAlert("Vendor updated successfully!", "success");
//                    }
//                    else
//                    {
//                        // Create new vendor
//                        int createdByUserId = Convert.ToInt32(Session["UserId"] ?? "1");
//                        string ipAddress = GetClientIPAddress();

//                        api.CreateVendor(
//                            txtVendorName.Text.Trim(),
//                            txtEmail.Text.Trim(),
//                            txtPhoneNumber.Text.Trim(),
//                            txtPassword.Text,
//                            createdByUserId,
//                            ipAddress
//                        );

//                        ShowAlert("Vendor created successfully!", "success");
//                    }
//                    CloseModalAndReset();
//                    LoadVendors();
//                }
//                catch (Exception ex)
//                {
//                    ShowAlert("An error occurred: " + ex.Message, "danger");
//                    ShowModalAfterError();
//                }
//            }
//        }
//        protected void gvVendors_RowCommand(object sender, GridViewCommandEventArgs e)
//        {
//            int vendorId = Convert.ToInt32(e.CommandArgument);

//            if (e.CommandName == "EditVendor")
//            {
//                EditVendor(vendorId);
//            }
//            else if (e.CommandName == "DeleteVendor")
//            {
//                DeleteVendor(vendorId);
//            }
//        }
//        private void EditVendor(int vendorId)
//        {
//            try
//            {
//                var api = new schoolfeesapi.schoolfeesapi();
//                DataTable dt = api.GetVendorById(vendorId);

//                if (dt.Rows.Count > 0)
//                {
//                    DataRow row = dt.Rows[0];
//                    hfEditingVendorId.Value = vendorId.ToString();
//                    txtVendorName.Text = row["VendorName"].ToString();
//                    txtEmail.Text = row["Email"].ToString();
//                    txtPhoneNumber.Text = row["PhoneNumber"].ToString();
//                    txtPassword.Text = "";
//                    ddlIsApproved.SelectedValue = row["IsApproved"].ToString();
//                    ddlIsActive.SelectedValue = row["IsActive"].ToString();
//                    modalTitle.InnerText = "Edit Vendor";
//                    btnSave.Text = "Update Vendor";

//                    pnlAlert.Visible = false;
//                    ShowEditModal();
//                }
//            }
//            catch (Exception ex)
//            {
//                ShowAlert("Failed to load vendor details: " + ex.Message, "danger");
//            }
//        }
//        private void DeleteVendor(int vendorId)
//        {
//            try
//            {
//                var api = new UserManagementAPI.UserManagementAPI();
//                int deletedByUserId = Convert.ToInt32(Session["UserId"] ?? "1");
//                string ipAddress = GetClientIPAddress();

//                api.DeleteVendor(vendorId, deletedByUserId, ipAddress);
//                ShowAlert("Vendor deactivated successfully!", "success");
//                LoadVendors();
//            }
//            catch (Exception ex)
//            {
//                ShowAlert("Failed to deactivate vendor: " + ex.Message, "danger");
//            }
//        }

//        private void ShowAlert(string message, string alertType)
//        {
//            lblMessage.Text = message;
//            pnlAlert.CssClass = $"alert alert-{alertType} alert-dismissible fade show mb-3";
//            pnlAlert.Visible = true;

//            // Scroll to top to show the alert
//            ClientScript.RegisterStartupScript(this.GetType(), "ScrollToTop", "window.scrollTo(0, 0);", true);
//        }

//        private void ClearForm()
//        {
//            txtVendorName.Text = string.Empty;
//            txtEmail.Text = string.Empty;
//            txtPhoneNumber.Text = string.Empty;
//            txtPassword.Text = string.Empty;
//            ddlIsApproved.SelectedIndex = 0;
//            ddlIsActive.SelectedIndex = 0;
//            hfEditingVendorId.Value = string.Empty;
//            pnlAlert.Visible = false;

//            // Reset to create mode
//            btnSave.Text = "Create Vendor";
//            modalTitle.InnerText = "Create New Vendor";
//        }

//        private void CloseModalAndReset()
//        {
//            ClearForm();
//            string closeScript = @"
//                // Close the modal
//                const modal = bootstrap.Modal.getInstance(document.getElementById('createVendorModal'));
//                if (modal) {
//                    modal.hide();
//                } else {
//                    const newModal = new bootstrap.Modal(document.getElementById('createVendorModal'));
//                    newModal.hide();
//                }
                
//                // Ensure form is reset after modal closes
//                setTimeout(function() {
//                    resetModalForm();
//                }, 300);
//            ";

//            ScriptManager.RegisterStartupScript(this, this.GetType(), "closeModalAndReset", closeScript, true);
//        }

//        private void ShowEditModal()
//        {
//            string script = @"
//                setTimeout(function() {
//                    // Set edit mode first
//                    setEditMode();
                    
//                    // Then show the modal
//                    const modal = new bootstrap.Modal(document.getElementById('createVendorModal'));
//                    modal.show();
//                }, 100);
//            ";

//            ScriptManager.RegisterStartupScript(this, this.GetType(), "showEditModal", script, true);
//        }

//        private void ShowModalAfterError()
//        {
//            string showModalScript = @"
//                setTimeout(function() {
//                    const modal = new bootstrap.Modal(document.getElementById('createVendorModal'));
//                    modal.show();
//                }, 100);
//            ";

//            ScriptManager.RegisterStartupScript(this, this.GetType(), "showModalOnError", showModalScript, true);
//        }

//        private string GetClientIPAddress()
//        {
//            string ipAddress = string.Empty;

//            try
//            {
//                ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

//                if (string.IsNullOrEmpty(ipAddress) || ipAddress.ToLower() == "unknown")
//                {
//                    ipAddress = Request.ServerVariables["HTTP_X_REAL_IP"];
//                }

//                if (string.IsNullOrEmpty(ipAddress) || ipAddress.ToLower() == "unknown")
//                {
//                    ipAddress = Request.ServerVariables["REMOTE_ADDR"];
//                }

//                if (string.IsNullOrEmpty(ipAddress))
//                {
//                    ipAddress = Request.UserHostAddress;
//                }
//                if (!string.IsNullOrEmpty(ipAddress) && ipAddress.Contains(","))
//                {
//                    ipAddress = ipAddress.Split(',')[0].Trim();
//                }
//                if (string.IsNullOrEmpty(ipAddress))
//                {
//                    ipAddress = "127.0.0.1";
//                }
//            }
//            catch
//            {
//                ipAddress = "127.0.0.1";
//            }

//            return ipAddress;
//        }
//        [System.Web.Services.WebMethod]
//        public static void ResetModalState()
//        {

//        }
//    }
//}
