<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" 
    Inherits="UserForms.Login.ChangePassword" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow border-0">
                    <div class="card-body p-4">
                        <h4 class="mb-3 text-center text-primary">Change Password</h4>

                        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                            <asp:Label ID="lblMessage" runat="server" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </asp:Panel>

                        <div class="mb-3">
                            <asp:Label ID="lblNewPassword" runat="server" Text="New Password" CssClass="form-label fw-semibold" />
                            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="New password is required." CssClass="text-danger" Display="Dynamic" />
                        </div>

                        <div class="mb-4">
                            <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password" CssClass="form-label fw-semibold" />
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" />
                            <asp:CompareValidator ID="cvPasswords" runat="server" ControlToCompare="txtNewPassword" ControlToValidate="txtConfirmPassword" ErrorMessage="Passwords do not match." CssClass="text-danger" Display="Dynamic" />
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm password." CssClass="text-danger" Display="Dynamic" />
                        </div>

                        <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn btn-success w-100" OnClick="btnChangePassword_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
