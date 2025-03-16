# Video Rental DBMS Project  
**Author:** [Your Name]  
**Course:** [Course Name]  
**University:** Toronto Metropolitan University  
**Date:** [Date]  

---

## Project Overview  
This project is a **Video Rental Database Management System (DBMS)** that allows users to manage rental transactions, customers, equipment inventory, and payments efficiently. It includes:  

- **Database Schema**: Tables for storing customer, equipment, rentals, maintenance, and payments data.  
- **SQL Queries**: Various queries for data retrieval and analysis.  
- **Java GUI Application**: A simple Java-based Swing GUI to interact with the database.  
- **Testing Scripts**: A test script (`TestConnection.java`) to check database connectivity.  

---

## 1. Database Schema  
The database consists of the following tables:  

1. **Customer Table (`customer`)**  
   - Stores customer details like `customer_id`, `name`, and `email`.  

2. **Equipment Table (`equipment`)**  
   - Stores rental equipment details such as `equipment_id`, `name`, `type`, `availability`, and `price`.  

3. **Rentals Table (`rentals`)**  
   - Tracks rental transactions, linking customers with rented equipment and storing rental dates and return status.  

4. **Payments Table (`payments`)**  
   - Logs payments made by customers for rentals, including `payment_id`, `rental_id`, `payment_amount`, `payment_date`, and `payment_method`.  

5. **Maintenance Table (`maintenance`)**  
   - Tracks maintenance records for rented equipment.  

---

## 2. SQL Queries (`queries.sql`)  
The project includes multiple SQL queries to:  

- Retrieve and sort equipment by price.  
- Identify available stock.  
- List rentals with outstanding payments.  
- Find equipment that has never been rented.  
- Count customer rentals.  
- Validate **BCNF and Normalization** constraints.  

These queries help maintain database integrity and provide essential analytics for managing the video rental business.  

---

## 3. Java GUI Application (`DatabaseGUI.java`)  
A **Java Swing-based GUI** allows users to interact with the database using an intuitive interface.  

### Features:  
✔ Create and drop database tables.  
✔ Populate tables with sample data.  
✔ Execute custom SQL queries.  
✔ Display query results in a text area.  

### How to Run:  
1. Ensure you have **Oracle JDBC Driver** (`ojdbc.jar`) in your classpath.  
2. Compile and run the GUI:  
   ```sh
   javac DatabaseGUI.java  
   java DatabaseGUI  
