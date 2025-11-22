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

<img width="3071" height="1166" alt="image" src="https://github.com/user-attachments/assets/54fee7a3-bec1-4927-8f93-fe71f03e9d8f" />

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

<img width="1969" height="532" alt="image" src="https://github.com/user-attachments/assets/91a1113d-3936-4e26-92e8-e93c1b3f3945" />
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
<img width="1935" height="512" alt="image" src="https://github.com/user-attachments/assets/d9d2c9d1-cd3d-4d86-ae6c-81522a2c2d65" />

---

## 4. SYSTEM ARCHITECTURE DIAGRAM
*Visual representation of the MVC flow implemented in Part A.*

**[PLACEHOLDER: INSERT YOUR MVC ARCHITECTURE DIAGRAM HERE]**
*(Tip: You can draw a simple diagram showing: Browser -> LoginController -> UserDAO -> Database)*
