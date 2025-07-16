<%@ Page Title="User Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs"
    Inherits="UserForms.Admin.Users.UserManagement" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .form-control.is-valid {
        border-color: #198754;
    }
    .form-control.is-invalid {
        border-color: #dc3545;
    }
</style>

<div class="container-fluid">
<div class="row justify-content-center">
<div class="col-12">

<!-- Landing Page with Button -->
<asp:Panel ID="pnlLanding" runat="server" Visible="true">
<div class="d-flex justify-content-between align-items-start mb-4">
<div></div>
<button type="button" class="btn btn-success btn-lg px-4" data-bs-toggle="modal" data-bs-target="#createVendorModal">
Create New Vendor
</button>
</div>
</asp:Panel>

<!-- Create Vendor Modal -->
<div class="modal fade" id="createVendorModal" tabindex="-1">
<div class="modal-dialog modal-lg">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title text-primary fw-bold" id="modalTitle" runat="server">Create New Vendor</h5>
<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
</div>
<div class="modal-body">

<!-- Alert Panel -->
<asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-3">
<asp:Label ID="lblMessage" runat="server"></asp:Label>
<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<asp:HiddenField ID="hfEditingVendorId" runat="server" />

<!-- Vendor Name -->
<div class="mb-3">
    <asp:Label ID="lblVendorName" runat="server" Text="Vendor Name" CssClass="form-label fw-semibold"></asp:Label>
    <asp:TextBox ID="txtVendorName" runat="server" CssClass="form-control" placeholder="Enter vendor name" MaxLength="100"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvVendorName" runat="server" 
        ControlToValidate="txtVendorName"
        ErrorMessage="Required"
        CssClass="text-danger small"
        Display="Dynamic"
        ValidationGroup="VendorForm"></asp:RequiredFieldValidator>
</div>

<div class="row">
<!-- Email -->
<div class="col-md-6 mb-3">
    <asp:Label ID="lblEmail" runat="server" Text="Email Address" CssClass="form-label fw-semibold"></asp:Label>
    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="vendor@example.com" MaxLength="100" TextMode="Email"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
        ControlToValidate="txtEmail"
        ErrorMessage="Required"
        CssClass="text-danger small"
        Display="Dynamic"
        ValidationGroup="VendorForm"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="revEmail" runat="server"
        ControlToValidate="txtEmail"
        ErrorMessage="Invalid email format"
        CssClass="text-danger small"
        Display="Dynamic"
        ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
        ValidationGroup="VendorForm"></asp:RegularExpressionValidator>
</div>

<!-- Phone Number -->
<div class="col-md-6 mb-3">
    <asp:Label ID="lblPhoneNumber" runat="server" Text="Phone Number" CssClass="form-label fw-semibold"></asp:Label>
    <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control" placeholder="+256777778888" MaxLength="13"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvPhoneNumber" runat="server"
        ControlToValidate="txtPhoneNumber"
        ErrorMessage="Required"
        CssClass="text-danger small"
        Display="Dynamic"
        ValidationGroup="VendorForm"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="revPhoneNumber" runat="server"
        ControlToValidate="txtPhoneNumber"
        ErrorMessage="Phone number must be exactly 13 digits including country code (e.g., +256777778888)"
        CssClass="text-danger small"
        Display="Dynamic"
        ValidationExpression="^\+\d{12}$"
        ValidationGroup="VendorForm"></asp:RegularExpressionValidator>
    <div class="form-text">Format: +256777778888 (exactly 13 digits)</div>
</div>
</div>

<!-- Password -->
<div class="mb-3">
    <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="form-label fw-semibold"></asp:Label>
    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Enter password" TextMode="Password" MaxLength="50"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
        ControlToValidate="txtPassword"
        ErrorMessage="Required"
        CssClass="text-danger small"
        Display="Dynamic"
        ValidationGroup="VendorForm"></asp:RequiredFieldValidator>
    <div class="form-text">
        <span id="passwordHint">Password must be at least 6 characters long</span>
        <span id="editPasswordHint" style="display:none;">Leave blank to keep current password</span>
    </div>
</div>

<div class="row">
<!-- Is Approved -->
<div class="col-md-6 mb-3">
    <asp:Label ID="lblIsApproved" runat="server" Text="Approval Status" CssClass="form-label fw-semibold"></asp:Label>
    <asp:DropDownList ID="ddlIsApproved" runat="server" CssClass="form-select">
        <asp:ListItem Text="Pending Approval" Value="False" Selected="True"></asp:ListItem>
        <asp:ListItem Text="Approved" Value="True"></asp:ListItem>
    </asp:DropDownList>
</div>

<!-- Is Active -->
<div class="col-md-6 mb-3">
    <asp:Label ID="lblIsActive" runat="server" Text="Status" CssClass="form-label fw-semibold"></asp:Label>
    <asp:DropDownList ID="ddlIsActive" runat="server" CssClass="form-select">
        <asp:ListItem Text="Active" Value="True" Selected="True"></asp:ListItem>
        <asp:ListItem Text="Inactive" Value="False"></asp:ListItem>
    </asp:DropDownList>
</div>
</div>

</div>
<div class="modal-footer">
    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
    <asp:Button ID="btnSave" runat="server" Text="Create Vendor"
        CssClass="btn btn-success"
        OnClick="btnSave_Click"
        ValidationGroup="VendorForm" />
</div>
</div>
</div>
</div>

<!-- Vendor Filter + Listing Table -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body">
        <h5 class="text-primary fw-bold mb-3">View Vendors</h5>
        
        <!-- Vendor Grid -->
        <asp:GridView ID="gvVendors" runat="server" CssClass="table table-bordered table-hover"
                      AutoGenerateColumns="False" EmptyDataText="No vendors found."
                      DataKeyNames="VendorId" OnRowCommand="gvVendors_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="No.">
                <ItemTemplate>
                <%# Container.DataItemIndex + 1 %>
                </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="VendorName" HeaderText="Vendor Name" />
                <asp:BoundField DataField="VendorCode" HeaderText="Vendor Code" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" />
                <asp:BoundField DataField="AccountNumber" HeaderText="Account Number" />
                <asp:TemplateField HeaderText="Approved">
                    <ItemTemplate>
                        <span class="badge <%# Convert.ToBoolean(Eval("IsApproved")) ? "bg-success" : "bg-warning" %>">
                            <%# Convert.ToBoolean(Eval("IsApproved")) ? "Yes" : "Pending" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="badge <%# Convert.ToBoolean(Eval("IsActive")) ? "bg-success" : "bg-danger" %>">
                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedAt" HeaderText="Created" DataFormatString="{0:yyyy-MM-dd}" />
                
                <%-- Action Buttons --%>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <div class="d-flex gap-1">
                        <asp:Button ID="btnEdit" runat="server" Text="Edit"
                             CommandName="EditVendor"
                             CommandArgument='<%# Eval("VendorId") %>'
                             CssClass="btn btn-sm btn-primary me-2"
                             CausesValidation="false" />
                        <asp:Button ID="btnDelete" runat="server" Text="Delete"
                             CommandName="DeleteVendor"
                             CommandArgument='<%# Eval("VendorId") %>'
                             CssClass="btn btn-sm btn-danger"
                             CausesValidation="false"
                             OnClientClick="return confirm('Are you sure you want to delete this vendor?');" />
                            </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>
<!--end of vendor table-->

</div>
</div>
</div>

<script>
    // Enhanced modal handling
    document.addEventListener('DOMContentLoaded', function () {
        const modal = document.getElementById('createVendorModal');

        // Initialize phone number formatting
        initializePhoneNumber();

        // Reset form when modal is closed
        modal.addEventListener('hidden.bs.modal', function () {
            resetModalForm();
        });

        // Clear any alerts when modal opens
        modal.addEventListener('shown.bs.modal', function () {
            // Hide alert if visible when modal opens
            const alertPanel = document.getElementById('<%= pnlAlert.ClientID %>');
            if (alertPanel) {
                alertPanel.style.display = 'none';
            }

            // Focus on first input
            document.getElementById('<%= txtVendorName.ClientID %>').focus();
        });
    });

    function initializePhoneNumber() {
        const phoneInput = document.getElementById('<%= txtPhoneNumber.ClientID %>');

        phoneInput.addEventListener('input', function (e) {
            let value = e.target.value;

            // Remove all non-digit characters except + at the beginning
            let cleaned = value.replace(/[^\d+]/g, '');

            // Ensure it starts with + and only one +
            if (!cleaned.startsWith('+')) {
                cleaned = '+' + cleaned.replace(/\+/g, '');
            } else {
                // Remove any additional + signs after the first one
                cleaned = '+' + cleaned.substring(1).replace(/\+/g, '');
            }

            // Limit to exactly 13 characters (+XXX + 9 digits)
            if (cleaned.length > 13) {
                cleaned = cleaned.substring(0, 13);
            }

            e.target.value = cleaned;

            // Visual feedback for valid length
            if (cleaned.length === 13) {
                e.target.classList.remove('is-invalid');
                e.target.classList.add('is-valid');
            } else {
                e.target.classList.remove('is-valid');
                if (cleaned.length > 1) { // Don't show invalid for just "+"
                    e.target.classList.add('is-invalid');
                }
            }
        });

        phoneInput.addEventListener('keydown', function (e) {
            // Allow backspace, delete, tab, escape, enter
            if ([8, 9, 27, 13, 46].indexOf(e.keyCode) !== -1 ||
                // Allow Ctrl+A, Ctrl+C, Ctrl+V, Ctrl+X
                (e.keyCode === 65 && e.ctrlKey === true) ||
                (e.keyCode === 67 && e.ctrlKey === true) ||
                (e.keyCode === 86 && e.ctrlKey === true) ||
                (e.keyCode === 88 && e.ctrlKey === true)) {
                return;
            }

            // Ensure that it is a number or + (only at the beginning)
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                // Allow + only at the beginning
                if (!(e.keyCode === 187 && e.shiftKey && e.target.selectionStart === 0 && e.target.value === '')) {
                    e.preventDefault();
                }
            }
        });

        phoneInput.addEventListener('paste', function (e) {
            setTimeout(() => {
                let value = e.target.value;
                let cleaned = value.replace(/[^\d+]/g, '');

                if (!cleaned.startsWith('+')) {
                    cleaned = '+' + cleaned.replace(/\+/g, '');
                } else {
                    cleaned = '+' + cleaned.substring(1).replace(/\+/g, '');
                }

                if (cleaned.length > 13) {
                    cleaned = cleaned.substring(0, 13);
                }

                e.target.value = cleaned;

                // Trigger input event to apply visual feedback
                phoneInput.dispatchEvent(new Event('input'));
            }, 0);
        });
    }

    function resetModalForm() {
        // Reset modal title and save button to "Create"
        document.getElementById('<%= modalTitle.ClientID %>').innerText = "Create New Vendor";
        document.getElementById('<%= btnSave.ClientID %>').innerText = "Create Vendor";
        
        // Clear form fields
        document.getElementById('<%= txtVendorName.ClientID %>').value = '';
        document.getElementById('<%= txtEmail.ClientID %>').value = '';
        
        // Clear phone number field (don't prefill)
        const phoneInput = document.getElementById('<%= txtPhoneNumber.ClientID %>');
        phoneInput.value = '';
        phoneInput.classList.remove('is-valid', 'is-invalid');
        
        document.getElementById('<%= txtPassword.ClientID %>').value = '';
        document.getElementById('<%= ddlIsApproved.ClientID %>').selectedIndex = 0;
        document.getElementById('<%= ddlIsActive.ClientID %>').selectedIndex = 0;
        
        // Clear hidden field
        document.getElementById('<%= hfEditingVendorId.ClientID %>').value = '';
        
        // Hide alert if visible
        const alertPanel = document.getElementById('<%= pnlAlert.ClientID %>');
        if (alertPanel) {
            alertPanel.style.display = 'none';
        }
        
        // Reset password hints
        document.getElementById('passwordHint').style.display = '';
        document.getElementById('editPasswordHint').style.display = 'none';
        
        // Reset password field requirement for create mode
        const passwordValidator = document.getElementById('<%= rfvPassword.ClientID %>');
        if (passwordValidator) {
            passwordValidator.style.display = '';
        }
    }

    // Function to handle edit mode (called from code-behind)
    function setEditMode() {
        document.getElementById('passwordHint').style.display = 'none';
        document.getElementById('editPasswordHint').style.display = '';
        
        // Make password optional in edit mode
        const passwordValidator = document.getElementById('<%= rfvPassword.ClientID %>');
        if (passwordValidator) {
            passwordValidator.style.display = 'none';
        }
    }
</script>
</asp:Content>

