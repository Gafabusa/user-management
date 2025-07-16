<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" 
    Inherits="UserForms.Admin.Dashboard" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body text-center">
                    <div class="badge bg-primary bg-opacity-10 text-primary rounded-circle p-3 mb-3">
                        <h4 class="mb-0">👥</h4>
                    </div>
                    <h3 class="text-primary mb-1">248</h3>
                    <p class="text-muted mb-0">Total Users</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body text-center">
                    <div class="badge bg-success bg-opacity-10 text-success rounded-circle p-3 mb-3">
                        <h4 class="mb-0">✅</h4>
                    </div>
                    <h3 class="text-success mb-1">192</h3>
                    <p class="text-muted mb-0">Active Users</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body text-center">
                    <div class="badge bg-warning bg-opacity-10 text-warning rounded-circle p-3 mb-3">
                        <h4 class="mb-0">🔐</h4>
                    </div>
                    <h3 class="text-warning mb-1">4</h3>
                    <p class="text-muted mb-0">User Roles</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body text-center">
                    <div class="badge bg-info bg-opacity-10 text-info rounded-circle p-3 mb-3">
                        <h4 class="mb-0">📊</h4>
                    </div>
                    <h3 class="text-info mb-1">12</h3>
                    <p class="text-muted mb-0">New This Month</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Dashboard Content -->
    <div class="card border-0 shadow-sm">
        <div class="card-body">
            <h5 class="card-title">Welcome to Dashboard</h5>
            <p class="card-text">This is your main dashboard content area.</p>
        </div>
    </div>
</asp:Content>
