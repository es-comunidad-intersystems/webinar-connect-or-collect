-- Create a table in the database
CREATE TABLE orders (
    Id SERIAL Primary key,
    Invoice VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(100),
    Quantity INTEGER,
    InvoiceDate Date,
    Price NUMERIC,
    CustomerId VARCHAR(10),
    Country VARCHAR(50)
);

-- Load data from the CSV file into the table
COPY orders(Invoice, StockCode,Description, Quantity,InvoiceDate,Price,CustomerId,Country)
FROM '/onlinestore/online_retail_2011.csv'
DELIMITER ','
CSV HEADER;