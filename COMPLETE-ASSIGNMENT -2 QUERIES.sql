
/*
Task 1: Understanding the data in hand


A. Describe the data in hand in your own words. 
	1.   cust_dimen: Details of all the customers
    
		 customer_Name (TEXT): Name of the customer
         Province (TEXT): Province of the customer
         Region (TEXT): Region of the customer
         Customer_Segment (TEXT): Segment of the customer
         Cust_id (TEXT): Unique Customer ID
	
    2. market_fact: Details of every order item sold
		
        Ord_id (TEXT): Order ID
        Prod_id (TEXT): Prod ID
        Ship_id (TEXT): Shipment ID
        Cust_id (TEXT): Customer ID
        Sales (DOUBLE): Sales from the Item sold
        Discount (DOUBLE): Discount on the Item sold
        Order_Quantity (INT): Order Quantity of the Item sold
        Profit (DOUBLE): Profit from the Item sold
        Shipping_Cost (DOUBLE): Shipping Cost of the Item sold
        Product_Base_Margin (DOUBLE): Product Base Margin on the Item sold
        
    3. orders_dimen: Details of every order placed
		
        Order_ID (INT): Order ID
        Order_Date (TEXT): Order Date
        Order_Priority (TEXT): Priority of the Order
        Ord_id (TEXT): Unique Order ID
	
    4. prod_dimen: Details of product category and sub category
		
        Product_Category (TEXT): Product Category
        Product_Sub_Category (TEXT): Product Sub Category
        Prod_id (TEXT): Unique Product ID
	
    5. shipping_dimen: Details of shipping of orders
		
        Order_ID (INT): Order ID
        Ship_Mode (TEXT): Shipping Mode
        Ship_Date (TEXT): Shipping Date
        Ship_id (TEXT): Unique Shipment ID
        
        
B. Identify and list the Primary Keys and Foreign Keys for this dataset
	
	1. cust_dimen
    
		Primary Key: Cust_id
        Foreign Key: NA
	
    2. market_fact
    
		Primary Key: NA
        Foreign Key: Ord_id, Prod_id, Ship_id, Cust_id
	
    3. orders_dimen
    
		Primary Key: Ord_id
        Foreign Key: NA
	
    4. prod_dimen
    
		Primary Key: Prod_id, Product_Sub_Category
        Foreign Key: NA
	
    5. shipping_dimen
    
		Primary Key: Ship_id
        Foreign Key: NA
 */


/*
Task 2:- Basic & Advanced Analysis
*/

USE superstores ;

/*1----Write a query to display the Customer_Name and Customer Segment
       using alias name “Customer Name", "Customer Segment" from table Cust_dimen.*/
 
 SELECT Customer_Name as 'Customer Name', Customer_Segment as 'Customer Segment'
 FROM cust_dimen
 ;
 

/*2---Write a query to find all the details of the customer from the table cust_dimen order by desc.*/


SELECT *
FROM cust_dimen
ORDER BY Customer_Name DESC
;



/*3--Write a query to get the Order ID, Order date from table orders_dimen where ‘Order Priority’ is high.*/


SELECT Order_ID, Order_Date 
FROM orders_dimen
WHERE Order_Priority = 'HIGH'
;



/*4--Find the total and the average sales (display total_sales and avg_sales)*/

SELECT SUM(Sales) as 'total_sales', AVG(Sales) as 'avg_sales'
FROM market_fact
;



/*5---Write a query to get the maximum and minimum sales from maket_fact table.*/

 SELECT MAX(Sales) as 'max', MIN(Sales) as 'min'
 FROM market_fact
 ;
 
 
 
 /*6--Display the number of customers in each region in decreasing order of no_of_customers. 
 The result should contain columns Region, no_of_customers.*/
 
 SELECT Region, COUNT(Customer_Name) as no_of_customers
 FROM cust_dimen
 GROUP BY Region
 ORDER BY COUNT(Customer_Name) DESC
 ;
 
 
 
 /*7---Find the region having maximum customers (display the region name and max(no_of_customers)*/
 
 SELECT Region, COUNT(Customer_Name) as no_of_customers
 FROM cust_dimen
 GROUP BY Region
 ORDER BY COUNT(Customer_Name) DESC 
 ;
 

 
 /*8---Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased
  (display the customer name, no_of_tables purchased)*/
  
  
  SELECT c.customer_name, COUNT(*) as no_of_tables_purchased
  FROM market_fact m
  INNER JOIN
  cust_dimen c on m.Cust_id  = c.Cust_id
  WHERE c.Region = 'atlantic'
  AND m.Prod_id= (SELECT prod_id FROM prod_dimen WHERE product_Sub_Category = 'TABLES')
  GROUP BY m.Cust_id , c.Customer_Name
  ;
  
  
  
  /*9---Find all the customers from Ontario province who own Small Business. 
  (display the customer name, no of small business owners)*/
  
  
  SELECT customer_name, COUNT(*) as 'no of small buisness owners'
  FROM cust_dimen
  WHERE Province = 'Ontario'
  AND Customer_Segment = 'SMALL BUSINES'
  GROUP BY Customer_Name
  ;
  
  
  /*
  10--Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
  */
  
SELECT Prod_id as product_id, COUNT(*) as no_of_products_sold
FROM market_fact
 GROUP BY Prod_id
 ORDER BY no_of_products_sold DESC
 ;
  
  
  
/*
11----Display product Id and product sub category whose produt category belongs to Furniture and Technlogy.
      The result should contain columns product id, product sub category.
*/


SELECT Prod_id, Product_Sub_Category
FROM prod_dimen
WHERE Product_Category = 'Furniture'
OR Product_Category =  'Technology'
;
  

/*
12--Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
*/


SELECT p.Product_Category,  SUM(m.Profit) as profits
FROM market_fact m
INNER JOIN
prod_dimen p on m.Prod_id = p.Prod_id
GROUP BY p.Product_Category
ORDER BY profits DESC
;


  /*
  13--Display the product category, product sub-category and the profit within each subcategory in three columns.
  */
  
  
  SELECT p.Product_Category, p.Product_Sub_Category, SUM(m.Profit) as Profit
  FROM market_fact m
  INNER JOIN
  prod_dimen p on m.Prod_id = p.Prod_id
  GROUP BY p.Product_Category, p.Product_Sub_Category
  ;
  
  
  /*
  14----Display the order date, order quantity and the sales for the order.
  */
  
  SELECT  o.Order_Date, m.Order_Quantity,  m.Sales as Sales
  FROM orders_dimen o
  INNER JOIN 
  market_fact m on o.Ord_id = m.Ord_id
  ;
  
  
  
  /*
  15----Display the names of the customers whose name contains the
i) Second letter as ‘R’
ii) Fourth letter as ‘D’
  */
  

  SELECT Customer_Name 
  FROM cust_dimen
  WHERE instr(Customer_Name, 'R') = 2
  OR  instr(Customer_Name, 'D') = 4
  ;
  
  
  /*
  16------Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and 
          their region where sales are between 1000 and 5000
  */
  
  
  SELECT  c.Cust_id, c.Customer_Name, c.Region, m.Sales as Sales
  FROM cust_dimen c
  INNER JOIN market_fact m on c.Cust_id = M.Cust_id
  WHERE Sales BETWEEN 1000 AND 5000
  GROUP BY Cust_id
  ;
  
  
  
  /*
  17---Write a SQL query to find the 3rd highest sales.
  */
  
  SELECT MIN(Sales) as '3rd Highest Sales'
  FROM
  (
  SELECT Sales from superstores.market_fact ORDER BY Sales DESC limit 3)as a
  ;
  
  
  
  
  
  /*
  18---Where is the least profitable product subcategory shipped the most? 
  For the least profitable product sub-category, display the region-wise no_of_shipments and the
  profit made in each region in decreasing order of profits 
  (i.e. region, no_of_shipments, profit_in_each_region)
*/
  
	
select Region,count(Ship_id) as no_of_shipment,sum(Profit) as profit_in_each_region
 from superstores.cust_dimen c,superstores.market_fact s,superstores.prod_dimen p
where c.Cust_id = s.Cust_id and s.Prod_id = p.Prod_id
group by Region
order by profit_in_each_region DESC
;