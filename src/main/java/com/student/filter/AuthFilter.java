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

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final String[] PUBLIC_URLS = {
            "/login", "/logout", ".css", ".js", ".png", ".jpg", ".jpeg"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Init code
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        // --- AUTO LOGIN via COOKIE ---
        if (!isLoggedIn) {
            String username = getCookieValue(httpRequest, "rememberUser");
            if (username != null) {
                // Found a cookie, let's find the user
                UserDAO dao = new UserDAO();
                User user = dao.getUserByUsername(username);
                if (user != null) {
                    // Login success! Create session
                    session = httpRequest.getSession(true);
                    session.setAttribute("user", user);
                    session.setAttribute("role", user.getRole());
                    session.setAttribute("fullName", user.getFullName());
                    isLoggedIn = true;
                }
            }
        }
        // -----------------------------

        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    // Helper to find cookie
    private String getCookieValue(HttpServletRequest req, String name) {
        if (req.getCookies() != null) {
            for (Cookie c : req.getCookies()) {
                if (name.equals(c.getName())) return c.getValue();
            }
        }
        return null;
    }

    private boolean isPublicUrl(String path) {
        for (String publicUrl : PUBLIC_URLS) {
            if (path.contains(publicUrl)) return true;
        }
        return false;
    }

    @Override
    public void destroy() {}
}