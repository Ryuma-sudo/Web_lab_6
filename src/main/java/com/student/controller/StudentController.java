package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.model.Student;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new": showNewForm(request, response); break;
            case "edit": showEditForm(request, response); break;
            case "delete": deleteStudent(request, response); break;
            case "search": searchStudents(request, response); break;
            case "sort": sortStudents(request, response); break;
            case "filter": filterStudents(request, response); break;
            default: listStudents(request, response); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("insert".equals(action)) insertStudent(request, response);
        else if ("update".equals(action)) updateStudent(request, response);
        else listStudents(request, response);
    }

    // --- PAGINATION IMPLEMENTATION ---
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get Page Number from URL (default to 1)
        int page = 1;
        int pageSize = 5; // Set how many students per page

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 2. Fetch Data
        int totalStudents = studentDAO.getTotalStudents();
        List<Student> students = studentDAO.getStudentsByPage(page, pageSize);

        // 3. Calculate Total Pages
        int totalPages = (int) Math.ceil((double) totalStudents / pageSize);

        // 4. Set Attributes for JSP
        request.setAttribute("students", students);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }

    // --- Keep other methods as they were ---
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;
        String codePattern = "[A-Z]{2}[0-9]{3,}";
        if (student.getStudentCode() == null || student.getStudentCode().trim().isEmpty()) {
            request.setAttribute("errorCode", "Student code is required");
            isValid = false;
        } else if (!student.getStudentCode().matches(codePattern)) {
            request.setAttribute("errorCode", "Invalid format (e.g., SV001)");
            isValid = false;
        }
        if (student.getFullName() == null || student.getFullName().trim().length() < 2) {
            request.setAttribute("errorName", "Name must be at least 2 chars");
            isValid = false;
        }
        if (student.getMajor() == null || student.getMajor().trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required");
            isValid = false;
        }
        return isValid;
    }

    private void searchStudents(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Student> students = (keyword != null && !keyword.isEmpty()) ? studentDAO.searchStudents(keyword) : studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
    }

    private void sortStudents(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        List<Student> students = studentDAO.getStudentsSorted(sortBy, order);
        request.setAttribute("students", students);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
    }

    private void filterStudents(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String major = request.getParameter("major");
        List<Student> students = (major != null && !major.isEmpty()) ? studentDAO.getStudentsByMajor(major) : studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.setAttribute("selectedMajor", major);
        request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/student-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Student student = studentDAO.getStudentById(id);
        request.setAttribute("student", student);
        request.getRequestDispatcher("/views/student-form.jsp").forward(request, response);
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Student student = new Student(request.getParameter("studentCode"), request.getParameter("fullName"), request.getParameter("email"), request.getParameter("major"));
        if (!validateStudent(student, request)) {
            request.setAttribute("student", student);
            request.getRequestDispatcher("/views/student-form.jsp").forward(request, response);
            return;
        }
        if (studentDAO.addStudent(student)) response.sendRedirect("student?action=list&message=Added successfully");
        else response.sendRedirect("student?action=list&error=Failed to add");
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Student student = new Student(request.getParameter("studentCode"), request.getParameter("fullName"), request.getParameter("email"), request.getParameter("major"));
        student.setId(Integer.parseInt(request.getParameter("id")));
        if (!validateStudent(student, request)) {
            request.setAttribute("student", student);
            request.getRequestDispatcher("/views/student-form.jsp").forward(request, response);
            return;
        }
        if (studentDAO.updateStudent(student)) response.sendRedirect("student?action=list&message=Updated successfully");
        else response.sendRedirect("student?action=list&error=Failed to update");
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (studentDAO.deleteStudent(Integer.parseInt(request.getParameter("id")))) response.sendRedirect("student?action=list&message=Deleted successfully");
        else response.sendRedirect("student?action=list&error=Failed to delete");
    }
}