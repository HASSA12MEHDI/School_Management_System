School_Management_System
School management system on aspx and c#
# 🏫 School Management System

📘 Overview
The **School Management System** is an ASP.NET Web Forms–based web application designed to help manage key school operations including attendance, teacher and student records, fee management, and budgeting.  
It uses **SQL Server** as the backend database and includes several modules that work together for smooth administration.

---

 🚀 Features
- 📚 **Student Management** – Add, update, and view student details.  
- 👩‍🏫 **Teacher Management** – Manage teacher information, salaries, and related data.  
- 💰 **Fee Management** – Handle student fee payments, pending balances, and receipts.  
- 🧾 **Budget Management** – Record income, expenses, and calculate remaining school funds.  
- 📅 **Attendance Module** – Track attendance for students and teachers.  
- 🧮 **Reports & Calculations** – View total income, total expenses, and current financial balance.

---

Technologies Used
- **Frontend:** ASP.NET Web Forms, HTML5, CSS3, JavaScript  
- **Backend:** C# (.NET Framework)  
- **Database:** SQL Server (LocalDB or full SQL Server)  
- **Version Control:** Git & GitHub  

---

 🗂️ Project Structure
School_Management_System/
│
├── App_Data/ # Database files (.mdf, .ldf)

├── Pages/ # ASPX pages for modules (Students, Teachers, Budget, etc.)

├── Scripts/ # JavaScript / jQuery scripts

├── Styles/ # CSS files for page design

├── Web.config # Application configuration file

└── README.md # Project documentation



---

💾 Database Setup
1. Open **SQL Server Management Studio (SSMS)** or **Visual Studio Server Explorer**.  
2. Attach the provided `.mdf` database file from `App_Data/`.  
3. Update the connection string in `Web.config` if needed:
   ```xml
  <connectionStrings>
	<add name="SchoolConnectionString"
		 connectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf;Integrated Security=True"
		providerName="System.Data.SqlClient"  />
</connectionStrings>


🖥️ How to Run the Project

Clone the repository:
 git clone https://github.com/HASSA12MEHDI/School_Management_System.git
Open the project in Visual Studio.

Build and run (Ctrl + F5).

The application will open in your default web browser.

Open the project in Visual Studio.

Build and run (Ctrl + F5).

The application will open in your default web browser.

Author

Hassan Mehdi Bhanbhro
📧 hm95447025@gmail.com

💼 Skills: HTML, CSS, Java, C#, SQL, ASP.NET, Database Management

Future Improvements

Add chart visualizations for income and expenses.

Create a login system with roles (Admin, Teacher, Accountant).

Add downloadable reports (PDF/Excel).

Migrate to ASP.NET MVC or Blazor for modern UI.
