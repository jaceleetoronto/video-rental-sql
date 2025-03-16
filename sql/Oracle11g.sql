CREATE TABLE customer (
	customer_id	NUMBER	PRIMARY KEY,
	name 		VARCHAR2(100) NOT NULL,
	email		VARCHAR2(100) 
);


CREATE TABLE equipment (
	equipment_id 	NUMBER 	PRIMARY KEY,
	name		VARCHAR2(100) NOT NULL,
	type		VARCHAR2(50),
	availability	CHAR(1) DEFAULT 'N' CHECK (availability = ‘Y’ OR availability = ‘N’) NOT NULL,
	price		NUMBER
);

CREATE TABLE rentals (
	rental_id	    	NUMBER	PRIMARY KEY,
	equipment_id		NUMBER  NOT NULL,
	customer_id 		NUMBER  NOT NULL,
    	rental_date	    	 DATE,
    	return_date	   	 DATE,
    	amount_due	   	 NUMBER CHECK (amount_due >= 0),
   	FOREIGN KEY     (customer_id) REFERENCES customer(customer_id),
    	FOREIGN KEY     (equipment_id) REFERENCES equipment(equipment_id)
);

CREATE TABLE payments (
	payment_id		NUMBER 	PRIMARY KEY,
	rental_id		NUMBER	REFERENCES rentals(rental_id),
	payment_amount	NUMBER CHECK (payment_amount >= 0),		
	payment_date		DATE,
	payment_method	VARCHAR2(50),
	FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
); 

CREATE TABLE maintenance (
   	maintenance_id	    NUMBER	PRIMARY KEY,
    	equipment_id	    NUMBER	NOT NULL,
	description	        VARCHAR2(100),
	maintenance_date    DATE,
	maintenance_cost    NUMBER,
	status		        VARCHAR2(1),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);


--Creating a view that shows available equipment with the type and price.
CREATE VIEW available_equipment AS
SELECT equipment_id, name, type, price
FROM equipment
WHERE availability = 'Y';

--Creating a view that shows the rental information associated with each customer.
CREATE VIEW customer_rentals AS
SELECT c.customer_id, c.name, r.rental_id, r.equipment_id, r.rental_date, r.return_date, r.amount_due
FROM customer c
JOIN rentals r ON c.customer_id = r.customer_id;


--Shows customers with outstanding payments for rentals.
CREATE VIEW outstanding_payments AS
SELECT r.rental_id, r.amount_due, c.name
FROM rentals r
JOIN customer c ON r.customer_id = c.customer_id
WHERE amount_due > 0;

--Shows how much each customer spent through rental payments.
CREATE VIEW customer_revenue AS
SELECT c.customer_id, c.name, SUM(r.amount_due) AS total_revenue
FROM customer c
JOIN rentals r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.name;





