--query 1: display equipment sorted by price in ascending order
SELECT name, availability, price
FROM equipment
ORDER BY price ASC; 


--query 2: displays which equipment types have available stock
SELECT DISTINCT type
FROM equipment
WHERE availability = 'Y';

--query 3: shows equipment that are undergoing maintenance, ordered by equipment type
SELECT e.type, e.name, m.maintenance_date, m.status
FROM equipment e
JOIN maintenance m ON e.equipment_id = m.equipment_id
WHERE m.status = 'Y'
ORDER BY e.type ASC;

--query 4: shows how many payments total are using each payment method
SELECT payment_method, COUNT(*) AS method_count
FROM payments
GROUP BY payment_method

--query 5: sorts names in ascending order
SELECT name, email
FROM customer
ORDER BY name ASC;

--query 6: shows rentals where the equipment has not been returned yet
SELECT rental_id, customer_id, equipment_id, rental_date
FROM rentals
WHERE return_date IS NULL;

--query 7: lists maintenance tasks where the maintenance cost is above 500
SELECT maintenance_id, equipment_id, description, maintenance_cost
FROM maintenance
WHERE maintenance_cost > 500;

--query 8: find all the rentals made in September
SELECT rental_id, customer_id, equipment_id, rental_date
FROM rentals
WHERE rental_date BETWEEN TO_DATE('2024-09-01', 'YYYY-MM-DD') AND TO_DATE('2024-09-30', 'YYYY-MM-DD');

--query 9: Shows which equipment has never been rented
SELECT equipment_id
FROM equipment
WHERE equipment_id NOT IN (SELECT equipment_id FROM rentals);



-- ++

--query 1:
SELECT *
FROM available_equipment
ORDER BY price ASC;

--query 2:
SELECT c.name, p.payment_date, r.return_date
FROM rentals r
JOIN customer c ON r.customer_id = c.customer_id
JOIN payments p ON r.rental_id = p.rental_id

--query 3:
SELECT e.name, COUNT(r.rental_id) as rental_count, COUNT(m.maintenance_id) as mnt_count
FROM equipment e
JOIN rentals r ON e.equipment_id = r.equipment_id
JOIN maintenance m ON e.equipment_id = m.equipment_id
GROUP BY e.name
ORDER BY rental_count ASC;

--query 4:
SELECT c.name AS customer, e.name AS equipment, r.rental_date
FROM rentals r
JOIN customer c ON r.customer_id = c.customer_id
JOIN equipment e ON r.equipment_id = e.equipment_id
ORDER BY c.name ASC;


-- Addtional:

-- query 1: Find customers who have made rentals but haven't made any payments yet.
SELECT c.customer_id, c.name
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM rentals r
    WHERE r.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM payments p
    JOIN rentals r ON p.rental_id = r.rental_id
    WHERE r.customer_id = c.customer_id
);

--query 2: Show equipment that is available but has never been rented.
SELECT equipment_id, name
FROM available_equipment
MINUS
SELECT e.equipment_id, e.name
FROM equipment e
JOIN rentals r ON e.equipment_id = r.equipment_id;

--query 3: Count how many rentals each customer has made, showing only customers with more than 2 rentals.
SELECT c.name, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rentals r ON c.customer_id = r.customer_id
GROUP BY c.name
HAVING COUNT(r.rental_id) > 2;

--query 4: Find all customers who have rented equipment but have no outstanding payments.
SELECT c.customer_id, c.name
FROM customer c
JOIN rentals r ON c.customer_id = r.customer_id
LEFT JOIN payments p ON r.rental_id = p.rental_id
WHERE r.amount_due = 0 AND p.rental_id IS NULL

UNION

SELECT c.customer_id, c.name
FROM customer c
JOIN rentals r ON c.customer_id = r.customer_id
WHERE r.rental_id NOT IN (
    SELECT op.rental_id
    FROM outstanding_payments op
);

--query 5: Show the average rental amount due by equipment type.
SELECT e.type, AVG(r.amount_due) AS avg_due
FROM equipment e
JOIN rentals r ON e.equipment_id = r.equipment_id
GROUP BY e.type;


--SELECT * FROM rentals;

SELECT c.customer_id, c.name, r.rental_id
FROM customer c
JOIN rentals r ON c.customer_id = r.customer_id;


-- Assignment 6: 
-- validates FD for table 1.

SELECT customer_id, name, email, COUNT(*)
FROM customer
GROUP BY customer_id, name, email
HAVING COUNT(*) > 1;

-- validates FD for equipment table.
SELECT equipment_id, name, type, availability, price, COUNT(*)
FROM equipment
GROUP BY equipment_id, name, type, availability, price
HAVING COUNT(*) > 1;

-- validates FD for rentals table.
SELECT rental_id, equipment_id, customer_id, rental_date, return_date, amount_due, COUNT(*)
FROM rentals
GROUP BY rental_id, equipment_id, customer_id, rental_date, return_date, amount_due
HAVING COUNT(*) > 1;

-- validates FD for payments table.
SELECT payment_id, rental_id, payment_amount, payment_date, payment_method, COUNT(*)
FROM payments
GROUP BY payment_id, rental_id, payment_amount, payment_date, payment_method
HAVING COUNT(*) > 1;

-- validates FD for maintenance table.
SELECT maintenance_id, equipment_id, description, maintenance_date, maintenance_cost, status, COUNT(*)
FROM maintenance
GROUP BY maintenance_id, equipment_id, description, maintenance_date, maintenance_cost, status
HAVING COUNT(*) > 1;

