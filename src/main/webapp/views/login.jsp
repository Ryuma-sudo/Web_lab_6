<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Student Management</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); height: 100vh; display: flex; justify-content: center; align-items: center; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); width: 100%; max-width: 400px; }
        h2 { text-align: center; color: #1e3a8a; margin-bottom: 30px; font-weight: 700; }

        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; color: #4b5563; font-weight: 600; }
        input[type="text"], input[type="password"] { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 8px; box-sizing: border-box; font-size: 15px; transition: all 0.2s; }
        input:focus { border-color: #3b82f6; outline: none; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

        /* REMEMBER ME STYLE */
        .remember-box { display: flex; align-items: center; margin-bottom: 20px; }
        .remember-box input { width: auto; margin-right: 10px; }
        .remember-box label { margin: 0; font-weight: 400; color: #666; cursor: pointer; }

        button { width: 100%; padding: 14px; background: #1e3a8a; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        button:hover { background: #1e40af; }

        .error-msg { background-color: #fee2e2; color: #991b1b; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; border: 1px solid #fca5a5; }
        .success-msg { background-color: #d1e7dd; color: #0f5132; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; border: 1px solid #badbcc; }

        .demo-info { margin-top: 25px; padding-top: 20px; border-top: 1px solid #e5e7eb; font-size: 13px; color: #6b7280; text-align: center; }
        .demo-info p { margin: 4px 0; }
    </style>
</head>
<body>
<div class="login-box">
    <h2>🎓 Student Portal</h2>

    <c:if test="${not empty error}"><div class="error-msg">❌ ${error}</div></c:if>
    <c:if test="${not empty param.message}"><div class="success-msg">✅ ${param.message}</div></c:if>

    <form action="login" method="post">
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Enter username" required autofocus>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter password" required>
        </div>

        <div class="remember-box">
            <input type="checkbox" id="remember" name="remember">
            <label for="remember">Keep me logged in</label>
        </div>

        <button type="submit">Sign In</button>
    </form>

    <div class="demo-info">
        <p><strong>Admin:</strong> admin / password123</p>
        <p><strong>User:</strong> user / password123</p>
    </div>
</div>
</body>
</html>