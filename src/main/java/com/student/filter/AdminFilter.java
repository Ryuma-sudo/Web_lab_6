package com.student.filter;

import com.student.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Exercise 6: Admin Authorization Filter
 * Restricts sensitive actions (create, update, delete) to Admin users only.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {"/student"})
public class AdminFilter implements Filter {

    // List of actions that require Admin privileges
    private static final String[] ADMIN_ACTIONS = {
            "new",      // Show add form
            "insert",   // Process add form
            "edit",     // Show edit form
            "update",   // Process edit form
            "delete"    // Delete student
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AdminFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get the 'action' parameter from the URL (e.g., student?action=delete)
        String action = httpRequest.getParameter("action");

        // 1. Check if the requested action is restricted
        if (isAdminAction(action)) {

            // Get current session
            HttpSession session = httpRequest.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            // 2. Verify if the user has Admin role
            if (user != null && user.isAdmin()) {
                // User is Admin, allow access
                chain.doFilter(request, response);
            } else {
                // User is NOT Admin, deny access
                // Redirect back to list with an error message
                String contextPath = httpRequest.getContextPath();
                httpResponse.sendRedirect(contextPath +
                        "/student?action=list&error=Access Denied! You do not have admin privileges.");
            }
        } else {
            // Action is public (e.g., list, search, filter), allow everyone
            chain.doFilter(request, response);
        }
    }

    /**
     * Helper to check if the action string is in the restricted list
     */
    private boolean isAdminAction(String action) {
        if (action == null) return false; // Default action (list) is safe

        for (String adminAction : ADMIN_ACTIONS) {
            if (adminAction.equals(action)) return true;
        }
        return false;
    }

    @Override
    public void destroy() {
    }
}