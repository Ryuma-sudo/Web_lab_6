package com.student.filter;

import com.student.dao.UserDAO;
import com.student.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Exercise 5: Authentication Filter
 * Intercepts all requests to ensure the user is logged in.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    // List of URLs that do not require authentication
    private static final String[] PUBLIC_URLS = {
            "/login",
            "/logout",
            ".css", ".js", ".png", ".jpg", ".jpeg", ".ico" // Static resources
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization log (optional)
        System.out.println("AuthFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get the current request path (e.g., "/dashboard" or "/student")
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // 1. Check if the requested URL is public
        if (isPublicUrl(path)) {
            // Allow access to public resources immediately
            chain.doFilter(request, response);
            return;
        }

        // 2. Check if the user is already logged in (Session check)
        HttpSession session = httpRequest.getSession(false); // false = do not create new session yet
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        // 3. If not logged in, check for "Remember Me" cookie (Auto-login feature)
        if (!isLoggedIn) {
            String username = getCookieValue(httpRequest, "rememberUser");
            if (username != null) {
                // Cookie found, attempt to retrieve user from DB
                UserDAO dao = new UserDAO();
                User user = dao.getUserByUsername(username);

                if (user != null) {
                    // User found, create a new session automatically
                    session = httpRequest.getSession(true);
                    session.setAttribute("user", user);
                    session.setAttribute("role", user.getRole());
                    session.setAttribute("fullName", user.getFullName());
                    isLoggedIn = true; // Mark as logged in
                }
            }
        }

        // 4. Final Access Decision
        if (isLoggedIn) {
            // User is authenticated, allow request to proceed
            chain.doFilter(request, response);
        } else {
            // User is not authenticated, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    /**
     * Helper method to check if a path is in the PUBLIC_URLS list
     */
    private boolean isPublicUrl(String path) {
        for (String publicUrl : PUBLIC_URLS) {
            if (path.contains(publicUrl)) return true;
        }
        return false;
    }

    /**
     * Helper method to retrieve a cookie value by name
     */
    private String getCookieValue(HttpServletRequest req, String name) {
        if (req.getCookies() != null) {
            for (Cookie c : req.getCookies()) {
                if (name.equals(c.getName())) return c.getValue();
            }
        }
        return null;
    }

    @Override
    public void destroy() {
        // Cleanup resources if needed
    }
}