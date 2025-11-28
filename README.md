# Lab 6: AUTHENTICATION & SESSION MANAGEMENT

**Course:** Web Application Development
**Student Name:** Nguyễn Quang Trực
**Student ID:** ICSIU23041
**Class:** Group 2

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
* Admin
<img width="3071" height="1166" alt="image" src="https://github.com/user-attachments/assets/54fee7a3-bec1-4927-8f93-fe71f03e9d8f" />

* User
<img width="3069" height="1142" alt="image" src="https://github.com/user-attachments/assets/ff417348-af5a-4607-90d7-9719e0ced51b" />

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
<img width="1969" height="532" alt="image" src="https://github.com/user-attachments/assets/91a1113d-3936-4e26-92e8-e93c1b3f3945" />

* User
<img width="1935" height="512" alt="image" src="https://github.com/user-attachments/assets/d9d2c9d1-cd3d-4d86-ae6c-81522a2c2d65" />

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

