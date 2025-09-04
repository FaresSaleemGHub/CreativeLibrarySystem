# 📚 Creative Library System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)<br>
A comprehensive library management system with integrated café and room reservation modules.

---

## 📋 Database Overview
CreativeLibrarySystem is designed as a modular relational database to support library operations combined with a café and room reservation system. It maintains:
- Users: customers, librarians, and cafe staff.
- Books: catalog, authors, copies, borrowing, and fines.
- Cafe: menu, orders, and item images.
- Rooms: study and conference rooms with reservation management.
- System Management: settings, permissions, and audit logs.
The database enforces data integrity via primary keys, foreign keys, unique constraints, check constraints, and default values.

---
## 🗂️ Database Modules
### 1. Members Module
Manages all users in the system: customers, librarians, and cafe staff.
Key Tables:
- [User]: Stores general user information such as name, email, password, phone, and join date.
- Membership: Defines membership types with discount rates and maximum allowed borrowed books.
- Customer: Extends users to store loyalty points and membership type.
- LibrarianPosition & Librarian: Stores librarian roles, salaries, and permissions.
- CafeStaffPosition & CafeStaff: Stores cafe staff roles, working hours, wage, and permissions.
- LibPermission & CaStPermission: Encodes role permissions using computed columns (bitwise representation).
Generalization / Specialization:
- [User] is the general entity; Customer, Librarian, and CafeStaff are specialized entities.
- Shared attributes are in [User], role-specific attributes are in specialized tables.

### 2. System Management Module
Handles system-wide settings and audit logs.
Key Tables:
- AuditLog: Logs all database actions (Add, Update, Delete) with timestamp and user reference.
- LibrarySetting: Singleton table storing library configuration such as max borrow days, fine rates, operating hours, login attempts, and tax rates.

### 3. Books Module
Manages books, authors, copies, borrowing, and fines.
Key Tables:
- BookCategory: Categories for books.
- Book: Book metadata including ISBN, publisher, and category.
- Author: Author information with nationality.
- BookAuthor: Many-to-many relation between books and authors.
- BookCopy: Tracks individual copies and status (Available, Borrowed, Lost, Damaged).
- Borrowing: Tracks borrowing transactions with due and return dates.
- BorrowingBookCopy: Links borrowed copies to transactions.
- Fine: Tracks fines for late returns or damages.
- Constraints: Borrowing ensures due_date >= borrow_date and return_date >= borrow_date. Fine payment dates cannot precede issue dates.

### 4. Cafe Module
Manages cafe menu items, orders, and item images.
Key Tables:
- ItemCategory: Categories of café items (e.g., drinks, snacks).
- CafeMenuItem: Menu items with price and category.
- ItemImage: Optional multiple images per menu item, with display order.
- [Order]: Customer orders, payment method, total amount, and status.
- CafeMenuItemOrder: Many-to-many relation between orders and menu items with quantity and unit price.

### 5. Rooms Module
Manages library room reservations for customers.
Key Tables:
- Room: Stores rooms with type (individual, group, conference, quiet, multimedia), capacity, and status.
- Reservation: Tracks reservations, including start/end times, status, and related librarian approval.
- Constraints: Ensures end_time >= start_time. Overlap prevention should be implemented at the application level.

---

## 3-Level Database Design
### 1. Conceptual Level
- Designed ERD with entities, relationships, and generalization/specialization.

### 2. Representational / Logical Level
- Transformed ERD into relational schema with primary keys, foreign keys, and constraints.
- Implemented junction tables for many-to-many relationships.
- Applied check constraints, unique constraints, and default values.

### 3. Physical Level
- SQL Server implementation with appropriate data types (NVARCHAR, INT, DECIMAL, DATE, DATETIME, TIME, BIT).
- Computed columns for bitmask-based permissions (LibPermission.value, CaStPermission.value).
- Singleton table LibrarySetting ensures one global configuration row.
- Audit logs and room reservation checks implemented at the database level.

---

## ✨ Key Features & Unique Implementations
This project includes several advanced and unique design decisions that demonstrate strong database modeling skills:
- ### Role-Based Permissions with Bitmasking
  LibPermission and CaStPermission tables use computed columns with powers of 2 to implement a bitmask-based permission system.
  This allows flexible combination of multiple permissions per role and efficient permission checks in queries.
- ### Singleton Table for Global Settings
  LibrarySetting ensures there is only one row storing global library configurations (max borrow days, fines, tax rate, operating hours, login attempts).
  This enforces a consistent configuration across the system.
- ### Audit Trail System 
  AuditLog table tracks all Add, Update, and Delete actions with user reference and timestamp.
  Supports system accountability and traceability.
- ### Support for Multi-Module Integration
  Combines library, café, and room reservation modules in a single database.
  Ensures consistent user management across modules.
- ### Computed Columns & Default Values
  Uses computed columns for permissions and default values for timestamps, statuses, and numeric fields.

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
