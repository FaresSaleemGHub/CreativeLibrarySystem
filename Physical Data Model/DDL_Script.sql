-- ======================================
-- Create Database if not exists
-- ======================================
IF NOT EXISTS (
    SELECT name FROM sys.databases WHERE name = N'CreativeLibrarySystem'
)
BEGIN
    CREATE DATABASE CreativeLibrarySystem;
END
GO

USE CreativeLibrarySystem;
GO

-- ======================================
-- 1. Members Module
-- ======================================

CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL, -- NVARCHAR(255) is fine for hashed passwords
    phone NVARCHAR(20) UNIQUE,
    date_of_birth DATE CHECK (date_of_birth < GETDATE()), -- DATE: Y-M-D
    join_date DATETIME DEFAULT GETDATE() -- DATETIME is more detailed,Y-M-D H:M:S
);

CREATE TABLE Membership (
    mem_id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(20) 
        CHECK (type IN ('Regular', 'Silver', 'Gold', 'Platinum', 'VIP')) UNIQUE,
    discount_rate DECIMAL(5,2) CHECK (discount_rate BETWEEN 0.00 AND 100.00) DEFAULT 0.00,
    max_books INT 
        CHECK (max_books >= 0)
);

CREATE TABLE Customer (
    user_id INT PRIMARY KEY,
    loyalty_point INT CHECK (loyalty_point >=0) DEFAULT 0,
    mem_id INT,
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (mem_id) REFERENCES Membership(mem_id)
);

CREATE TABLE LibrarianPosition (
    lib_pos_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE,
    salary DECIMAL(10,2) CHECK (salary >=0) DEFAULT 0,
    permission_value INT
);

CREATE TABLE Librarian (
    user_id INT PRIMARY KEY,
    lib_pos_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (lib_pos_id) REFERENCES LibrarianPosition(lib_pos_id)
);

CREATE TABLE CafeStaffPosition (
    caf_sta_pos_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE,
    working_hours INT CHECK (working_hours>0),
    wage_rate DECIMAL(10,2) CHECK (wage_rate >= 0),
    permission_value INT
);

CREATE TABLE CafeStaff (
    user_id INT PRIMARY KEY,
    caf_sta_pos_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES [User] (user_id),
    FOREIGN KEY (caf_sta_pos_id) REFERENCES CafeStaffPosition(caf_sta_pos_id) 
);

CREATE TABLE LibPermission (
    lib_per_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE,
    value AS POWER(2, lib_per_id - 1) PERSISTED -- Computed Collumn
);

CREATE TABLE CaStPermission (
    caf_sta_per_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE,
    value AS POWER(2, caf_sta_per_id - 1) PERSISTED -- Computed Collumn
);

-- ======================================
-- 2. System Management Module
-- ======================================

CREATE TABLE AuditLog( 
    audit_id INT IDENTITY(1,1) PRIMARY KEY, 
    action NVARCHAR(10) NOT NULL CHECK (action IN ('Add', 'Update', 'Delete')),  
    table_name NVARCHAR(100),  
    changed_by INT, 
    changed_at DATETIME DEFAULT GETDATE(),  
    record_id INT, 
    FOREIGN KEY (changed_by) REFERENCES [User](user_id)
);

CREATE TABLE LibrarySetting (
    lib_id INT PRIMARY KEY DEFAULT 1 CHECK (lib_id = 1), -- singleton row
    lib_name NVARCHAR(100) NOT NULL,  
    allow_overdue_borrow BIT DEFAULT 0,  
    max_borrow_days INT NOT NULL DEFAULT 14 CHECK (max_borrow_days >= 0),  
    daily_fine_rate DECIMAL(5,2) NOT NULL DEFAULT 0.5 CHECK (daily_fine_rate >= 0),  
    max_res_hou_day INT NOT NULL DEFAULT 1 CHECK (max_res_hou_day >= 0),  
    tax_rate DECIMAL(5,2) NOT NULL DEFAULT 0.5 CHECK (tax_rate >= 0),  
    lib_opening_time TIME NOT NULL,  
    lib_closing_time TIME NOT NULL,  
    max_login_attempt INT NOT NULL DEFAULT 3 CHECK (max_login_attempt >= 0), 
    CHECK (lib_opening_time < lib_closing_time) 
);
-- ⚠ CHECK (lib_opening_time < lib_closing_time) — will prevent overnight libraries (e.g., 20:00–02:00).

-- ======================================
-- 3. Books Module
-- ======================================

CREATE TABLE BookCategory (
    bok_cat_id INT IDENTITY(1,1) PRIMARY KEY, 
    name NVARCHAR (100) NOT NULL UNIQUE
);

CREATE TABLE Book (
    bok_id INT IDENTITY(1,1) PRIMARY KEY, 
    title NVARCHAR(200) NOT NULL,
    ISBN NVARCHAR(20) NOT NULL UNIQUE,
    description NVARCHAR(1000),
    publication_year SMALLINT, -- DATE works, but may be overkill. It's just YEAR
    publisher NVARCHAR(100), 
    bok_cat_id INT,
    FOREIGN KEY (bok_cat_id) REFERENCES BookCategory(bok_cat_id) -- ⚠ Best practice: Split FK definitions for clarity
);

CREATE TABLE Author (
    aut_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    nationality NVARCHAR(50),
    UNIQUE (name, nationality)
);

CREATE TABLE BookAuthor(
    bok_aut_id INT IDENTITY(1,1) PRIMARY KEY,
    bok_id INT,
    aut_id INT,
    FOREIGN KEY (bok_id) REFERENCES Book(bok_id),
    FOREIGN KEY (aut_id) REFERENCES Author(aut_id)
);

CREATE TABLE BookCopy(
    bok_cop_id INT IDENTITY(1,1) PRIMARY KEY,
    bok_id INT NOT NULL,
    shelf_location NVARCHAR(100),
    status NVARCHAR(50) 
        CHECK (status IN ('Available', 'Borrowed', 'Lost', 'Damaged'))
        DEFAULT 'Available',
    FOREIGN KEY (bok_id) REFERENCES Book(bok_id)
);

CREATE TABLE Borrowing (
    bor_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_date DATETIME DEFAULT GETDATE(), 
    due_date DATETIME, 
    return_date DATETIME,
    cust_id INT,
    lib_id INT,
    FOREIGN KEY (cust_id) REFERENCES Customer(user_id),
    FOREIGN KEY (lib_id) REFERENCES Librarian(user_id),
    -- Table-level CHECK constraints
    CHECK (due_date >= borrow_date), 
    CHECK (return_date IS NULL OR return_date >= borrow_date)  -- CHECK: prevents Null values unless mintioned
);

CREATE TABLE BorrowingBookCopy (
    bor_bk_cop_id INT IDENTITY(1,1) PRIMARY KEY,
    bok_cop_id INT,
    bor_id INT,
    FOREIGN KEY (bok_cop_id) REFERENCES BookCopy(bok_cop_id),
    FOREIGN KEY (bor_id) REFERENCES Borrowing(bor_id)
);

CREATE TABLE Fine (
    fin_id INT IDENTITY(1,1) PRIMARY KEY,
    amount DECIMAL (10,2) NOT NULL CHECK (amount >= 0),
    paid_status NVARCHAR(50) 
        CHECK (paid_status IN ('Paid', 'Unpaid')) 
        DEFAULT 'Unpaid', 
    issued_at DATETIME NOT NULL DEFAULT GETDATE(),
    due_date DATETIME,
    payment_date DATETIME,
    bor_id INT NOT NULL,
    FOREIGN KEY (bor_id) REFERENCES Borrowing(bor_id),
    CHECK (payment_date IS NULL OR payment_date >= issued_at), -- allowing NULL (unpaid fines)
);


-- ======================================
-- 3. Cafe Module
-- ======================================

CREATE TABLE ItemCategory (
    ite_cat_id INT IDENTITY (1,1) PRIMARY KEY, 
    category_name NVARCHAR (50) NOT NULL, 
    image_path NVARCHAR (255)
);

CREATE TABLE CafeMenuItem (
    caf_men_it_id INT IDENTITY (1,1) PRIMARY KEY,
    item_name NVARCHAR (50) NOT NULL, 
    price DECIMAL (10,2) NOT NULL CHECK (price >=0) DEFAULT 0,
    description NVARCHAR (500), 
    ite_cat_id INT,
    FOREIGN KEY (ite_cat_id) REFERENCES ItemCategory(ite_cat_id)
);

CREATE TABLE ItemImage (
    ite_img_id INT IDENTITY (1,1) PRIMARY KEY,
    image_path NVARCHAR (255), 
    display_order INT CHECK (display_order >= 0) DEFAULT 1, 
    caf_men_it_id INT,
    FOREIGN KEY (caf_men_it_id) REFERENCES CafeMenuItem(caf_men_it_id)
);

CREATE TABLE [Order] (
    ord_id INT IDENTITY (1,1) PRIMARY KEY, 
    cust_id INT,
    caf_sta_id INT,
    order_date DATETIME NOT NULL,
    payment_method NVARCHAR(50)
        CHECK (payment_method IN ('Cash', 'Credit Card', 'Mobile Payment'))
        DEFAULT 'Cash',
    total_amount DECIMAL (10,2) CHECK (total_amount >= 0),
    status NVARCHAR(50)
        CHECK (status IN ('Pending', 'Completed', 'Cancelled'))
        DEFAULT 'Pending',
    FOREIGN KEY (cust_id) REFERENCES Customer(user_id), 
    FOREIGN KEY (caf_sta_id) REFERENCES CafeStaff(user_id)
);

CREATE TABLE CafeMenuItemOrder ( 
    caf_men_ite_ord_id INT IDENTITY (1,1) PRIMARY KEY,  
    caf_men_it_id INT,  -- matches parent column name
    ord_id INT, 
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0), 
    unit_price DECIMAL (10,2) NOT NULL CHECK (unit_price >= 0), 
    FOREIGN KEY (caf_men_it_id) REFERENCES dbo.CafeMenuItem(caf_men_it_id),  
    FOREIGN KEY (ord_id) REFERENCES dbo.[Order](ord_id) 
);
-- ======================================
-- 5. Rooms Module
-- ======================================

CREATE TABLE Room (
    rom_id INT IDENTITY (1,1) PRIMARY KEY, 
    name NVARCHAR(100) NOT NULL UNIQUE, 
    capacity INT NOT NULL CHECK (capacity > 0), 
    type NVARCHAR (50) 
        CHECK (type IN ('individual', 'group', 'conference', 'quiet', 'multimedia')), 
    status NVARCHAR (50)
        CHECK (status IN ('Available', 'Occupied', 'Maintenance'))
        DEFAULT 'Available',
    location NVARCHAR(200)
);

CREATE TABLE Reservation (
    res_id INT IDENTITY (1,1) PRIMARY KEY, 
    rom_id INT,
    cust_id INT,
    lib_id INT FOREIGN KEY REFERENCES Librarian(user_id), 
    status  NVARCHAR (50)
        CHECK (status IN ('Pending', 'Reserved', 'Cancelled', 'Completed'))
        DEFAULT 'Pending',
    start_time DATETIME NOT NULL, 
    end_time DATETIME NOT NULL,
    FOREIGN KEY (rom_id) REFERENCES Room(rom_id), 
    FOREIGN KEY (cust_id) REFERENCES Customer(user_id),
    CHECK (end_time >= start_time), -- Reservation overlap prevention via application logic
);
