<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Student Management</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #f3f4f6; }

        /* NAVBAR */
        .navbar { background: #1e3a8a; color: white; padding: 0 30px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .navbar h3 { margin: 0; font-size: 20px; font-weight: 700; }
        .nav-links { display: flex; align-items: center; gap: 20px; }

        /* Nav Item Style */
        .nav-item { color: white; text-decoration: none; font-weight: 500; opacity: 0.9; transition: opacity 0.2s; font-size: 14px; }
        .nav-item:hover { opacity: 1; text-decoration: underline; }

        .user-badge { background: rgba(255,255,255,0.1); padding: 6px 12px; border-radius: 20px; font-size: 14px; display: flex; align-items: center; gap: 8px; }
        .btn-logout { background: #ef4444; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: 600; transition: background 0.2s; }
        .btn-logout:hover { background: #dc2626; }

        /* MAIN LAYOUT */
        .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
        .grid-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 25px; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border: 1px solid #e5e7eb; }
        .card h2 { color: #1f2937; font-size: 20px; margin-top: 0; margin-bottom: 15px; border-bottom: 2px solid #f3f4f6; padding-bottom: 15px; }

        /* STATS & OTHERS */
        .stat-box { text-align: center; padding: 20px; }
        .stat-number { font-size: 48px; font-weight: 800; color: #3b82f6; margin: 0; }
        .stat-label { color: #6b7280; font-size: 16px; font-weight: 500; text-transform: uppercase; letter-spacing: 1px; }
        .search-form { display: flex; gap: 10px; margin-top: 15px; }
        .search-input { flex: 1; padding: 12px; border: 1px solid #d1d5db; border-radius: 8px; font-size: 15px; }
        .search-btn { background: #3b82f6; color: white; border: none; padding: 0 20px; border-radius: 8px; font-weight: 600; cursor: pointer; }
        .action-buttons { display: flex; flex-direction: column; gap: 12px; }
        .btn-action { display: block; padding: 15px; text-align: center; text-decoration: none; border-radius: 8px; font-weight: 600; color: white; transition: transform 0.2s; }
        .btn-action:hover { transform: translateY(-2px); }
        .btn-primary { background: #1e3a8a; }
        .btn-success { background: #10b981; }
    </style>
</head>
<body>
<div class="navbar">
    <h3>📊 Dashboard</h3>
    <div class="nav-links">
        <div class="user-badge">👤 ${sessionScope.fullName} (${sessionScope.role})</div>

        <a href="change-password" class="nav-item">🔐 Change Password</a>

        <a href="logout" class="btn-logout">Logout ➡</a>
    </div>
</div>

<div class="container">
    <div class="card" style="margin-bottom: 30px; text-align: center;">
        <h1 style="color: #1e3a8a; margin: 0;">${welcomeMessage}</h1>
        <p style="color: #6b7280; margin-top: 10px;">Welcome to the Student Management System</p>
    </div>

    <div class="grid-container">
        <div class="card">
            <h2>📈 Overview</h2>
            <div class="stat-box">
                <p class="stat-number">${totalStudents}</p>
                <p class="stat-label">Total Students</p>
            </div>
        </div>

        <div class="card">
            <h2>🔍 Quick Search</h2>
            <form action="student" method="GET" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="search-input" placeholder="Enter keywords..." required>
                <button type="submit" class="search-btn">Search</button>
            </form>
        </div>

        <div class="card">
            <h2>⚡ Quick Actions</h2>
            <div class="action-buttons">
                <a href="student?action=list" class="btn-action btn-primary">📋 View All Students</a>
                <c:if test="${sessionScope.role eq 'admin'}">
                    <a href="student?action=new" class="btn-action btn-success">➕ Add New Student</a>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
</html>