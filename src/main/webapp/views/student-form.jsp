<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:choose><c:when test="${student != null && student.id != 0}">Edit Student</c:when><c:otherwise>Add Student</c:otherwise></c:choose></title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #f3f4f6; }

        /* SYNCHRONIZED NAVBAR */
        .navbar { background: #1e3a8a; color: white; padding: 0 30px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .navbar h3 { margin: 0; font-size: 20px; font-weight: 700; }
        .nav-links { display: flex; align-items: center; gap: 20px; }
        .user-badge { background: rgba(255,255,255,0.1); padding: 6px 12px; border-radius: 20px; font-size: 14px; }
        .btn-logout { background: #ef4444; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: 600; transition: background 0.2s; }

        .container { max-width: 600px; margin: 50px auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        h2 { color: #1e3a8a; margin-top: 0; margin-bottom: 25px; border-bottom: 2px solid #f3f4f6; padding-bottom: 15px; }

        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #374151; }

        input, select { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 8px; box-sizing: border-box; font-size: 15px; background: white; }
        input:focus, select:focus { border-color: #3b82f6; outline: none; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        input[readonly] { background-color: #f3f4f6; cursor: not-allowed; color: #6b7280; }

        .btn-row { margin-top: 30px; display: flex; gap: 15px; }
        .btn-submit { flex: 1; background-color: #10b981; color: white; padding: 12px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 16px; }
        .btn-submit:hover { background-color: #059669; }
        .btn-cancel { flex: 1; background-color: #6b7280; color: white; padding: 12px; text-decoration: none; border-radius: 8px; text-align: center; font-weight: 600; font-size: 16px; }
        .btn-cancel:hover { background-color: #4b5563; }

        .error-msg { color: #ef4444; font-size: 13px; margin-top: 5px; display: block; }
    </style>
</head>
<body>
<div class="navbar">
    <h3>📚 Student Management</h3>
    <div class="nav-links">
        <div class="user-badge">👤 ${sessionScope.fullName}</div>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="container">
    <h2>
        <c:choose>
            <c:when test="${student != null && student.id != 0}">✏️ Edit Student</c:when>
            <c:otherwise>➕ Add New Student</c:otherwise>
        </c:choose>
    </h2>

    <form action="student" method="POST">
        <input type="hidden" name="action" value="<c:out value="${student != null && student.id != 0 ? 'update' : 'insert'}"/>">
        <c:if test="${student != null && student.id != 0}">
            <input type="hidden" name="id" value="${student.id}">
        </c:if>

        <div class="form-group">
            <label>Student Code *</label>
            <input type="text" name="studentCode" value="${student.studentCode}"
                   <c:if test="${student != null && student.id != 0}">readonly</c:if> required>
            <c:if test="${not empty errorCode}"><span class="error-msg">⚠️ ${errorCode}</span></c:if>
        </div>

        <div class="form-group">
            <label>Full Name *</label>
            <input type="text" name="fullName" value="${student.fullName}" required>
            <c:if test="${not empty errorName}"><span class="error-msg">⚠️ ${errorName}</span></c:if>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="${student.email}">
            <c:if test="${not empty errorEmail}"><span class="error-msg">⚠️ ${errorEmail}</span></c:if>
        </div>

        <div class="form-group">
            <label>Major *</label>
            <select name="major" required>
                <option value="">-- Select Major --</option>
                <option value="Computer Science" ${student.major == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                <option value="Information Technology" ${student.major == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                <option value="Software Engineering" ${student.major == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                <option value="Business Administration" ${student.major == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
            </select>
            <c:if test="${not empty errorMajor}"><span class="error-msg">⚠️ ${errorMajor}</span></c:if>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn-submit">
                <c:choose>
                    <c:when test="${student != null && student.id != 0}">Save Changes</c:when>
                    <c:otherwise>Add Student</c:otherwise>
                </c:choose>
            </button>
            <a href="student?action=list" class="btn-cancel">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>