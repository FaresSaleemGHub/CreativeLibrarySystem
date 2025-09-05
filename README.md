# 🏛️ Fares T.H. Al-Sayed Saleem — Lecturer
Database Systems Lecturer | SQL, ERD, Relational & Physical Database Design | Academic & Practical Experience

---

## 📚 Creative Library System
A comprehensive **Database Management System (DBMS)** project designed to manage library operations, café services, and room reservations in a modern library environment.<br>
This project demonstrates database design at all three levels — Conceptual, Representational, and Physical — ensuring strong theoretical grounding and practical implementation.

---

### 📋 Database Project Overview
The CreativeLibrarySystem integrates:<br>
- Library members, librarians, and café staff
- Book cataloging, borrowing, fines, and audit logs
- Café menu management and ordering system
- Room reservations with librarian oversight
- System settings with singleton enforcement

---

### 🏗️ 3-Level Database Design
 **1. Conceptual Level**
- Entities: Users, Memberships, Books, Authors, Orders, Rooms<br>
- Relationships: Borrowing, Reservation, Book–Author (M:N)<br>
- Generalization/Specialization: User generalized into Customer, Librarian, Café Staff<br>
**🗺️ Entity–Relationship Diagram** → [View ERD](./Concceputal-Data-Model/ERD.png)

**2. Representational / Logical Level**
- Transformed ERD into relational schema with primary keys, foreign keys, and constraints.<br>
- Implemented junction tables for many-to-many relationships.<br>
- Applied check constraints, unique constraints, and default values.<br>
**📐 Full Relational Schema** → [View schema](./Representational-Data-Model/Relational_Schema_Notaion.txt)

**3. Physical Level**
Implemented in SQL Server with advanced features:<br>
- Bitmasking via computed columns (permissions)<br>
- Singleton row enforcement (LibrarySetting)<br>
- Audit logging for Add/Update/Delete<br>
- Check constraints for business rules (e.g., fine amount ≥ 0, reservation dates)<br>
**🖥️ SQL Script** → [Open DDL_Script.sql](./Physical-Data-Model/DDL_Script.sql)

---

### ✨ Key Features Implemented
This project includes several advanced and unique design decisions that demonstrate strong database modeling skills:
- **✔️ Generalization/Specialization**<br>
  User entity specialized into Customer, Librarian, CafeStaff
- **✔️ Bitmasking for Permissions**<br>
  LibPermission and CaStPermission tables use powers of 2 for flexible permission handling
- **✔️ Singleton Design Pattern**<br>
  LibrarySetting table restricted to only one row (lib_id = 1)
- **✔️ Audit Logging**<br>
  AuditLog table tracks all Add, Update, and Delete actions with user reference and timestamp.
- **✔️ Support for Multi-Module Integration**<br>
  Combines library, café, and room reservation modules in a single database.
- **✔️ Business Rule Constraints**<br>
  Automatic fine tracking
  Borrowing due date validation
  Reservation overlap prevention handled in application logic
- **✔️ Normalization & Integrity**<br>
  All tables 3NF
  Strong use of CHECK, DEFAULT, and UNIQUE constraints
- **✔️ Computed Columns & Default Values**<br>
  Uses computed columns for permissions and default values for timestamps, statuses, and numeric fields.

---

### 📂 Modules
- Members Module – Users, Memberships, Customers, Librarians, Café Staff
- System Management Module – Audit logs, library settings
- Books Module – Categories, Books, Authors, Borrowing, Fines
- Café Module – Menu items, orders, item categories
- Rooms Module – Rooms, Reservations

---

### 📖 Learning Outcomes
This project demonstrates:
- Complete 3-level database design process
- Advanced SQL Server features
- Enforcing real-world constraints in database layer
- Combining theory (ERD, normalization) with practice (SQL implementation)

---

### 📬 Connect with Me
- LinkedIn: [Fares Saleem](https://www.linkedin.com/in/fares-saleem-1578a8361/)  
- GitHub: [FaresSaleemGHub](https://github.com/FaresSaleemGHub)  
- Email: fareses11@hotmail.com

---

### ⚠️ Intellectual Property Notice<br>
All diagrams, scripts, and project designs in this repository are the intellectual property of **Fares T.H. Al-Sayed Saleem**.  
Do **not copy, redistribute, or claim ownership** without explicit permission from the author.
