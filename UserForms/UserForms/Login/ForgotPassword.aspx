<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/Login/LoginMaster.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="schoolfeesportal.Login.ForgotPassword" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid vh-100">
        <div class="row justify-content-center align-items-center" style="min-height: 80vh;">
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card shadow-lg border-0">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <h2 class="fw-bold text-primary mb-2">Reset Password</h2>
                            <p class="text-muted">Enter your details to reset your password</p>
                        </div>
                        
                        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-3">
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </asp:Panel>

                        <div class="mb-3">
                            <asp:Label ID="lblEmail" runat="server" Text="Email Address" CssClass="form-label fw-semibold"></asp:Label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-lg" 
                                placeholder="Enter your email address" TextMode="Email" required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                                ErrorMessage="Email is required" CssClass="text-danger small" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                                         

                        <div class="d-grid mb-3">
                            <asp:Button ID="btnResetPassword" runat="server" Text="Submit" CssClass="btn btn-primary btn-lg" 
                                OnClick="btnResetPassword_Click" />
                        </div>

                        <div class="text-center">
                            <asp:LinkButton ID="lnkBackToLogin" runat="server" CssClass="text-decoration-none text-secondary" 
                                OnClick="lnkBackToLogin_Click" CausesValidation="false">
                                ← Back to Login
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                  <p>&copy; <%: DateTime.Now.Year %>. All rights reserved</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
