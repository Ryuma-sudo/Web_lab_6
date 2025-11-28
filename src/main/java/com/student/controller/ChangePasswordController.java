package com.student.controller;

import com.student.dao.UserDAO;
import com.student.model.User;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Force login check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        // 1. Validation: Basic fields
        if (currentPass == null || newPass == null || confirmPass == null ||
                currentPass.isEmpty() || newPass.isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        // 2. Validation: New Password Strength
        if (newPass.length() < 6) {
            request.setAttribute("error", "New password must be at least 6 characters");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        // 3. Validation: Confirmation match
        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "New passwords do not match");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        // 4. Validation: Verify Current Password
        // IMPORTANT: Fetch the latest user data from DB to get the current hash
        User dbUser = userDAO.getUserById(currentUser.getId());
        if (dbUser == null || !BCrypt.checkpw(currentPass, dbUser.getPassword())) {
            request.setAttribute("error", "Incorrect current password");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        // 5. Update Password
        String newHash = BCrypt.hashpw(newPass, BCrypt.gensalt());
        boolean isUpdated = userDAO.updatePassword(currentUser.getId(), newHash);

        if (isUpdated) {
            request.setAttribute("message", "Password changed successfully!");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Database error. Please try again.");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
        }
    }
}