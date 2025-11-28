<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background-color: #f3f4f6; }

        /* NAVBAR */
        .navbar { background: #1e3a8a; color: white; padding: 0 30px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .navbar h3 { margin: 0; font-size: 20px; font-weight: 700; }
        .nav-links { display: flex; align-items: center; gap: 20px; }
        .nav-item { color: white; text-decoration: none; opacity: 0.9; }
        .nav-item:hover { opacity: 1; text-decoration: underline; }
        .btn-logout { background: #ef4444; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: 600; }

        .container { max-width: 500px; margin: 50px auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        h2 { color: #1e3a8a; margin-top: 0; margin-bottom: 25px; border-bottom: 2px solid #f3f4f6; padding-bottom: 15px; }

        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #374151; }
        input { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 8px; box-sizing: border-box; font-size: 15px; }
        input:focus { border-color: #3b82f6; outline: none; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

        button { width: 100%; padding: 14px; background: #10b981; color: white; border: none; border-radius: 8px; font-weight: 600; font-size: 16px; cursor: pointer; }
        button:hover { background-color: #059669; }

        .msg-error { background-color: #fee2e2; color: #991b1b; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; }
        .msg-success { background-color: #d1e7dd; color: #0f5132; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; }

        .back-link { display: block; text-align: center; margin-top: 20px; color: #6b7280; text-decoration: none; }
        .back-link:hover { color: #1f2937; }
    </style>
</head>
<body>
<div class="navbar">
    <h3>🔐 Security Settings</h3>
    <div class="nav-links">
        <a href="dashboard" class="nav-item">Dashboard</a>
        <a href="student" class="nav-item">Student List</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="container">
    <h2>Change Password</h2>

    <c:if test="${not empty error}">
        <div class="msg-error">❌ ${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="msg-success">✅ ${message}</div>
    </c:if>

    <form action="change-password" method="POST">
        <div class="form-group">
            <label>Current Password</label>
            <input type="password" name="currentPassword" required>
        </div>

        <div class="form-group">
            <label>New Password (min 6 chars)</label>
            <input type="password" name="newPassword" required>
        </div>

        <div class="form-group">
            <label>Confirm New Password</label>
            <input type="password" name="confirmPassword" required>
        </div>

        <button type="submit">Update Password</button>
    </form>

    <a href="dashboard" class="back-link">← Back to Dashboard</a>
</div>
</body>
</html>