# 📚 Creative Library System
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)<br>
A comprehensive Database Management System (DBMS) project designed to manage library operations, café services, and room reservations in a modern library environment.
This project demonstrates database design at all three levels — Conceptual, Representational, and Physical — ensuring strong theoretical grounding and practical implementation.

---

## 📋 Database Project Overview
The CreativeLibrarySystem integrates:<br>
- Library members, librarians, and café staff
- Book cataloging, borrowing, fines, and audit logs
- Café menu management and ordering system
- Room reservations with librarian oversight
- System settings with singleton enforcement

---

## 🏗️ 3-Level Database Design
### 1. Conceptual Level
- Entities: Users, Memberships, Books, Authors, Orders, Rooms
- Relationships: Borrowing, Reservation, Book–Author (M:N)
- Generalization/Specialization:
-- User generalized into Customer, Librarian, Café Staff
- 📊 Entity–Relationship Diagram → [View ERD](Concceputal Data Model/Entity Relationship Diagram_ERD.PNG)

### 2. Representational / Logical Level
- Transformed ERD into relational schema with primary keys, foreign keys, and constraints.
- Implemented junction tables for many-to-many relationships.
- Applied check constraints, unique constraints, and default values.
- 📜 Full Relational Schema → [View schema here](Representational Data Model/Relational Schema Notaion.txt)

### 3. Physical Level
- Implemented in SQL Server with advanced features:
-- Bitmasking via computed columns (permissions)
-- Singleton row enforcement (LibrarySetting)
-- Audit logging for Add/Update/Delete
-- Check constraints for business rules (e.g., fine amount ≥ 0, reservation dates)
🛠️ SQL Script → [Open CreativeLibrarySystem.sql](Physical Data Model/DDL_Script.sql)

---

## ✨ Key Features & Unique Implementations
This project includes several advanced and unique design decisions that demonstrate strong database modeling skills:
- ### ✔️ Generalization/Specialization<br>
  User entity specialized into Customer, Librarian, CafeStaff
- ### ✔️ Bitmasking for Permissions:
  LibPermission and CaStPermission tables use powers of 2 for flexible permission handling
- ### ✔️ Singleton Design Pattern:
  LibrarySetting table restricted to only one row (lib_id = 1)
- ### ✔️ Audit Logging:
  AuditLog table tracks all Add, Update, and Delete actions with user reference and timestamp.
- ### ✔️ Support for Multi-Module Integration<br>
  Combines library, café, and room reservation modules in a single database.
- ### ✔️ Business Rule Constraints:
  Automatic fine tracking
  Borrowing due date validation
  Reservation overlap prevention handled in application logic
- ### ✔️ Normalization & Integrity:
  All tables 3NF
  Strong use of CHECK, DEFAULT, and UNIQUE constraints
- ### ✔️ Computed Columns & Default Values<br>
  Uses computed columns for permissions and default values for timestamps, statuses, and numeric fields.

---

## 📂 Modules
- Members Module – Users, Memberships, Customers, Librarians, Café Staff
- System Management Module – Audit logs, library settings
- Books Module – Categories, Books, Authors, Borrowing, Fines
- Café Module – Menu items, orders, item categories
- Rooms Module – Rooms, Reservations

---

## 📖 Learning Outcomes
- This project demonstrates:
--- Complete 3-level database design process
--- Advanced SQL Server features
--- Enforcing real-world constraints in database layer
--- Combining theory (ERD, normalization) with practice (SQL implementation)

---

## 👤 Author
Fares T. H. Al-Sayed Saleem <br>
💻 Database Designer & Developer <br>
🌍 Gaza, Palestine <br>
📧 fareses11@hotmail.com <br>
🔗 [Github](https://github.com/FaresSaleemGHub)

---

## 📜 License
This project is open-source and available under the MIT License.
