<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #f3f4f6; }

        /* SYNCHRONIZED NAVBAR */
        .navbar { background: #1e3a8a; color: white; padding: 0 30px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .navbar h3 { margin: 0; font-size: 20px; font-weight: 700; }
        .nav-links { display: flex; align-items: center; gap: 20px; }
        .nav-item { color: white; text-decoration: none; font-weight: 500; opacity: 0.8; transition: opacity 0.2s; }
        .nav-item:hover { opacity: 1; }
        .user-badge { background: rgba(255,255,255,0.1); padding: 6px 12px; border-radius: 20px; font-size: 14px; }
        .btn-logout { background: #ef4444; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: 600; transition: background 0.2s; }
        .btn-logout:hover { background: #dc2626; }

        .container { max-width: 1100px; margin: 40px auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }

        /* HEADER & CONTROLS */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid #f3f4f6; padding-bottom: 15px; }
        h1 { color: #1e3a8a; margin: 0; font-size: 24px; }

        .btn-add { background-color: #10b981; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; }
        .btn-add:hover { background-color: #059669; }

        .controls { display: flex; gap: 15px; background: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #e5e7eb; margin-bottom: 25px; }
        .search-form { flex: 2; display: flex; gap: 10px; }
        .filter-form { flex: 1; display: flex; gap: 10px; }

        input, select { padding: 10px; border: 1px solid #d1d5db; border-radius: 6px; width: 100%; font-size: 14px; }
        button { padding: 10px 20px; background-color: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; }
        button:hover { background-color: #2563eb; }

        /* TABLE STYLES */
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #f1f5f9; color: #475569; padding: 15px; text-align: left; font-weight: 600; border-bottom: 2px solid #e2e8f0; }
        td { padding: 15px; border-bottom: 1px solid #e5e7eb; color: #374151; }
        tr:hover { background-color: #f9fafb; }

        th a { color: #475569; text-decoration: none; display: flex; align-items: center; gap: 5px; }

        .action-btn { padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; margin-right: 5px; }
        .btn-edit { background: #e0f2fe; color: #0369a1; }
        .btn-delete { background: #fee2e2; color: #991b1b; }

        /* PAGINATION */
        .pagination { display: flex; justify-content: center; margin-top: 30px; gap: 8px; }
        .pagination a, .pagination span { padding: 8px 16px; border: 1px solid #d1d5db; border-radius: 6px; text-decoration: none; color: #374151; background: white; }
        .pagination a:hover { background: #f3f4f6; }
        .pagination .active { background: #3b82f6; color: white; border-color: #3b82f6; }

        .msg { padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; }
        .msg-success { background: #d1e7dd; color: #0f5132; }
        .msg-error { background: #f8d7da; color: #842029; }
    </style>
</head>
<body>
<div class="navbar">
    <h3>📚 Student Management</h3>
    <div class="nav-links">
        <a href="dashboard" class="nav-item">📊 Dashboard</a>
        <div class="user-badge">👤 ${sessionScope.fullName}</div>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <h1>Student List</h1>
        <c:if test="${sessionScope.role == 'admin'}">
            <a href="student?action=new" class="btn-add">➕ Add Student</a>
        </c:if>
    </div>

    <c:if test="${not empty param.message}"><div class="msg msg-success">✅ ${param.message}</div></c:if>
    <c:if test="${not empty param.error}"><div class="msg msg-error">❌ ${param.error}</div></c:if>

    <div class="controls">
        <form action="student" method="get" class="search-form">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Search students..." value="${keyword}">
            <button type="submit">Search</button>
            <c:if test="${not empty keyword}"><a href="student?action=list" style="align-self:center; margin-left:10px; color:#64748b;">Clear</a></c:if>
        </form>
        <form action="student" method="get" class="filter-form">
            <input type="hidden" name="action" value="filter">
            <select name="major" onchange="this.form.submit()">
                <option value="">-- Filter by Major --</option>
                <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
            </select>
        </form>
    </div>

    <table>
        <thead>
        <tr>
            <th><a href="student?action=sort&sortBy=id&order=${sortBy == 'id' && order == 'asc' ? 'desc' : 'asc'}">ID ↕</a></th>
            <th><a href="student?action=sort&sortBy=student_code&order=${sortBy == 'student_code' && order == 'asc' ? 'desc' : 'asc'}">Code ↕</a></th>
            <th><a href="student?action=sort&sortBy=full_name&order=${sortBy == 'full_name' && order == 'asc' ? 'desc' : 'asc'}">Full Name ↕</a></th>
            <th><a href="student?action=sort&sortBy=email&order=${sortBy == 'email' && order == 'asc' ? 'desc' : 'asc'}">Email ↕</a></th>
            <th>Major</th>
            <c:if test="${sessionScope.role == 'admin'}"><th>Actions</th></c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="s" items="${students}">
            <tr>
                <td>${s.id}</td>
                <td>${s.studentCode}</td>
                <td>${s.fullName}</td>
                <td>${s.email}</td>
                <td>${s.major}</td>
                <c:if test="${sessionScope.role == 'admin'}">
                    <td>
                        <a href="student?action=edit&id=${s.id}" class="action-btn btn-edit">Edit</a>
                        <a href="student?action=delete&id=${s.id}" class="action-btn btn-delete" onclick="return confirm('Delete ${s.fullName}?')">Delete</a>
                    </td>
                </c:if>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a href="student?action=list&page=${currentPage - 1}">Previous</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${currentPage == i}"><span class="active">${i}</span></c:when>
                    <c:otherwise><a href="student?action=list&page=${i}">${i}</a></c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a href="student?action=list&page=${currentPage + 1}">Next</a>
            </c:if>
        </div>
    </c:if>
</div>
</body>
</html>