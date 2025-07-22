<%@ Page Title="System Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateUser.aspx.cs" 
    Inherits="UserForms.Admin.Users.CreateUser" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col-12">
                
    <!-- Landing Page with Button -->
<asp:Panel ID="pnlLanding" runat="server" Visible="true">
    <div class="d-flex justify-content-between align-items-start mb-4">
        <div></div> 
        <asp:Button ID="btnShowCreateUserForm" runat="server"
            Text="Create New User"
            CssClass="btn btn-success btn-lg px-4"
            OnClick="btnShowCreateUserForm_Click" />
    </div>      
</asp:Panel>


    <!-- Create User Form (Hidden Initially) -->
    <asp:Panel ID="pnlCreateUserForm" runat="server" Visible="false">
       <div class="row justify-content-center">
      <div class="col-12 col-md-6 col-lg-5">
          <div class="card shadow border-0 mt-4">
           <div class="card-body p-4">
             <div class="text-center mb-3">
            <h4 class="fw-bold text-primary mb-1">Create User</h4>
       <p class="text-muted small">Add a new system user</p>
       </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-3">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </asp:Panel>

    <!-- Full Name Field -->
    <div class="mb-3">
        <asp:Label ID="lblFullName" runat="server" Text="Full Name" CssClass="form-label fw-semibold"></asp:Label>
        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control w-100" placeholder="Enter full name" MaxLength="100" required="true"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Full name is required" CssClass="text-danger small" Display="Dynamic"></asp:RequiredFieldValidator>
    </div>

    <!-- Email Field -->
    <div class="mb-3">
        <asp:Label ID="lblEmail" runat="server" Text="Email Address" CssClass="form-label fw-semibold"></asp:Label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control w-100" placeholder="Enter email address" TextMode="Email" required="true"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger small" Display="Dynamic"></asp:RequiredFieldValidator>
    </div>

    <!-- Phone Number Field -->
    <div class="mb-4">
        <asp:Label ID="lblPhoneNumber" runat="server" Text="Phone Number" CssClass="form-label fw-semibold"></asp:Label>
        <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control w-100" placeholder="Enter phone number" MaxLength="10" required="true"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPhoneNumber" runat="server" ControlToValidate="txtPhoneNumber" ErrorMessage="Phone number is required" CssClass="text-danger small" Display="Dynamic"></asp:RequiredFieldValidator>
    </div>
               <!-- Role Dropdown Field -->
    <div class="mb-3">
        <asp:Label ID="lblRole" runat="server" Text="User Role" CssClass="form-label fw-semibold"></asp:Label>
        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select w-100" AppendDataBoundItems="true">
            <asp:ListItem Text="-- Select Role --" Value="" />
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="rfvRole" runat="server" ControlToValidate="ddlRole"
            InitialValue="" ErrorMessage="Please select a role"
            CssClass="text-danger small" Display="Dynamic" />
    </div>

    <!-- Action Buttons -->
    <div class="d-flex justify-content-center gap-2">
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary px-4" OnClick="btnCancel_Click" CausesValidation="false" UseSubmitBehavior="false" />
        <asp:Button ID="btnSave" runat="server" Text="Create User" CssClass="btn btn-success px-4" OnClick="btnSave_Click" />
    </div>
        </div>
    </div>
</div>
</div>
</asp:Panel>

            </div>
        </div>
    </div>
</asp:Content>
