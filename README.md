# Lab 6: AUTHENTICATION & SESSION MANAGEMENT

STUDENT INFORMATION:
- Name: Nguyễn Quang Trực
- Student ID: ITCSIU23041
- Class: Group 2

COMPLETED EXERCISES:
- [x] Exercise 1: Database & User Model
- [x] Exercise 2: User Model & DAO
- [x] Exercise 3: Login/Logout Controllers
- [x] Exercise 4: Views & Dashboard
- [x] Exercise 5: Authentication Filter
- [x] Exercise 6: Admin Authorization Filter
- [x] Exercise 7: Role-Based UI
- [x] Exercise 8: Change Password

AUTHENTICATION COMPONENTS:
- Models: User.java
- DAOs: UserDAO.java
- Controllers: LoginController.java, LogoutController.java, DashboardController.java
- Filters: AuthFilter.java, AdminFilter.java
- Views: login.jsp, dashboard.jsp, updated student-list.jsp

TEST CREDENTIALS:
Admin:
- Username: admin
- Password: password123

Regular User:
- Username: john
- Password: password123

FEATURES IMPLEMENTED:
- User authentication with BCrypt
- Session management
- Login/Logout functionality
- Dashboard with statistics
- Authentication filter for protected pages
- Admin authorization filter
- Role-based UI elements
- Password security
- Remember me

SECURITY MEASURES:
- BCrypt password hashing
- Session regeneration after login
- Session timeout (30 minutes)
- SQL injection prevention (PreparedStatement)
- Input validation
- XSS prevention (JSTL escaping)

---

# LAB REPORT: PART A - CODE FLOW ANALYSIS

## 1. AUTHENTICATION FLOW (LOGIN PROCESS)
This section details how the system handles a user attempting to log in.

### **Step 1: User Input (View Layer)**
* **File:** `login.jsp`
* **Action:** The user enters their credentials (username/password) and clicks "Sign In".
* **Data Flow:** The form data is bundled into an HTTP POST request and sent to the URL `/login`.

<img width="1815" height="1376" alt="image" src="https://github.com/user-attachments/assets/69453c17-d07b-4f5a-af53-99cf6b81053b" />

### **Step 2: Request Processing (Controller Layer)**
* **File:** `LoginController.java`
* **Method:** `doPost(HttpServletRequest request, ...)`
* **Action:**
    1.  **Retrieval:** The controller extracts `username` and `password`.
    2.  **Validation:** It checks if inputs are valid.
    3.  **Call:** It calls `userDAO.authenticate(u, p)`.

### **Step 3: Database Verification (Model Layer)**
* **File:** `UserDAO.java`
* **Method:** `authenticate(String username, String password)`
* **Action:**
    1.  **Query:** Executes `SELECT * FROM users WHERE username = ?`.
    2.  **Verify:** Uses `BCrypt.checkpw()` to compare the input password with the stored hash.

<img width="1426" height="203" alt="image" src="https://github.com/user-attachments/assets/38567cf5-fe98-4004-b499-7fc2764eeab7" />

### **Step 4: Session Creation (Controller Layer)**
* **File:** `LoginController.java`
* **Action:**
    * **Success:** Creates `HttpSession`, stores `User` object, and redirects to `/dashboard`.
    * **Failure:** Returns to login with an error message.

---

## 2. DASHBOARD ACCESS FLOW (SESSION MANAGEMENT)
This flow explains how the system ensures only logged-in users can access protected pages.

### **Step 1: Access Request**
* **Action:** User attempts to access `/dashboard`.

### **Step 2: Security Check (Controller Layer)**
* **File:** `DashboardController.java`
* **Method:** `doGet(...)`
* **Action:**
    1.  **Check:** Calls `request.getSession(false)` to retrieve the current session.
    2.  **Validate:** Verifies if `session.getAttribute("user")` is not null.

### **Step 3: Data Preparation & Rendering**
* **File:** `Dashboard.jsp`
* **Action:**
    1.  The Controller fetches statistics (e.g., `totalStudents`) and forwards to the View.
    2.  The View renders the "Add New Student" button only if `sessionScope.role == 'admin'`.
* Admin
<img width="3071" height="1166" alt="image" src="https://github.com/user-attachments/assets/54fee7a3-bec1-4927-8f93-fe71f03e9d8f" />

* User
<img width="3069" height="1142" alt="image" src="https://github.com/user-attachments/assets/ff417348-af5a-4607-90d7-9719e0ced51b" />

---

## 3. LOGOUT FLOW
This flow details how the system securely terminates a user session.

### **Step 1: Logout Trigger**
* **Action:** User clicks the "Logout" button.

### **Step 2: Session Destruction (Controller Layer)**
* **File:** `LogoutController.java`
* **Method:** `doGet(...)`
* **Action:**
    1.  **Invalidate:** Calls `session.invalidate()` to wipe server-side data.
    2.  **Cleanup:** Deletes `JSESSIONID` and `rememberUser` cookies.
    3.  **Redirect:** Sends user back to login with a success message.
  
<img width="926" height="1087" alt="image" src="https://github.com/user-attachments/assets/364d393a-50c8-4247-b509-5e57e10c60dc" />

---

## 4 CHANGE PASSWORD FLOW 

This section details the secure process of updating a user's password, ensuring properly validtion and hashing.

### **Step 1: Access & Form Display (GET Request)**

  * **Action:** User clicks "Change Password" on the Navbar.
  * **Controller:** `ChangePasswordController.doGet()` checks if the user is logged in.
      * If not logged in: Redirects to `/login`.
      * If logged in: Forwards to the view `change-password.jsp`.
  * **View:** Displays a form requiring Current Password, New Password, and Confirm Password.

<img width="1097" height="997" alt="image" src="https://github.com/user-attachments/assets/5852aa0a-a4d4-440b-a854-d98e31863eba" />

### **Step 2: Input Processing (Controller Layer)**

  * **File:** `ChangePasswordController.java`
  * **Method:** `doPost(HttpServletRequest request, ...)`
  * **Action:**
    1.  **Session Check:** Ensures the session is still valid.
    2.  **Input Retrieval:** Gets `currentPassword`, `newPassword`, and `confirmPassword` from the form.
    3.  **Validation:**
          * Checks for null/empty fields.
          * Checks if `newPassword` length \< 6 characters.
          * Checks if `newPassword` matches `confirmPassword`.

### **Step 3: Security Verification (Controller Logic)**

Before updating, the system must verify the user's identity again.

  * **Action:**
    1.  Retrieves the latest user data from the database using `userDAO.getUserById()`.
    2.  **Verify Old Password:** Uses `BCrypt.checkpw(currentInput, dbHash)` to ensure the user knows their current password.
    3.  **Hash New Password:** Generates a new salt and hash using `BCrypt.hashpw(newPassword, BCrypt.gensalt())`.

### **Step 4: Database Update (Model Layer)**

  * **File:** `UserDAO.java`
  * **Method:** `updatePassword(int userId, String newHashedPassword)`
  * **Action:** Executes the SQL Update query:
    ```sql
    UPDATE users SET password = ? WHERE id = ?
    ```
  * **Result:**
      * **Success:** Controller sets a success message attribute and reloads the page.
      * **Failure:** Controller sets an error message.

<img width="1079" height="1087" alt="image" src="https://github.com/user-attachments/assets/4465dc3c-39f0-4cb3-a394-aa64ae45f3ac" />
<img width="1087" height="1099" alt="image" src="https://github.com/user-attachments/assets/490daea2-69f1-4d58-b2b7-0bcf3ed710f2" />

---

## 5. ADMIN AUTHORIZATION FLOW (EXERCISE 6)
This section details how the `AdminFilter` protects sensitive operations (Create, Update, Delete) from unauthorized access.

### **Scenario:**
A user attempts to perform a restricted action, such as **Deleting a Student**.
* **URL:** `http://localhost:8080/StudentManagementMVC/student?action=delete&id=1`

### **Step 1: Request Interception (Filter Layer)**
* **File:** `AdminFilter.java`
* **Method:** `doFilter(ServletRequest request, ...)`
* **Action:**
    1.  The filter intercepts **every request** sent to the `/student` URL pattern.
    2.  It retrieves the `action` parameter from the request (e.g., `action="delete"`).

### **Step 2: Action Classification**
* **Logic:** The filter checks if the requested action is in the restricted `ADMIN_ACTIONS` list (new, insert, edit, update, delete).
    * `isAdminAction("delete")` returns **true**.
    * `isAdminAction("list")` returns **false**.

### **Step 3: Permission Verification**
If the action is restricted, the filter performs a deep check:
* **Action:**
    1.  Retrieves the current `HttpSession`.
    2.  Gets the `User` object: `User user = (User) session.getAttribute("user");`
    3.  Checks the role: `user.isAdmin()`.

### **Step 4: Access Decision**
* **Case A: User is Admin**
    * **Result:** `chain.doFilter(request, response)` is called.
    * **Outcome:** The request proceeds to `StudentController`, and the student is deleted.

* **Case B: User is NOT Admin (e.g., John)**
    * **Result:** The request is blocked immediately.
    * **Outcome:** The user is redirected to the student list with an error message:
      `response.sendRedirect(".../student?action=list&error=Access Denied!...")`

