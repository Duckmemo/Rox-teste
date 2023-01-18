CREATE TABLE product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Name VARCHAR(32),
    ProductNumber VARCHAR(60),
    MakeFlag INT,
    FinishedGoodsFlag INT,
    Color VARCHAR(255),
    SafetyStockLevel INT,
    ReorderPoint INT,
    StandardCost FLOAT,
    ListPrice FLOAT,
    Size VARCHAR(255),
    SizeUnitMeasureCode VARCHAR(255),
    WeightUnitMeasureCode VARCHAR(255),
    Weight FLOAT(6),
    DaysToManufacture INT,
    ProductLine VARCHAR(255),
    Class VARCHAR(255),
    Style VARCHAR(255),
    ProductSubcategoryID INT,
    ProductModelID INT,
    SellStartDate DATE,
    SellEndDate DATE,
    DiscontinuedDate DATE,
    rowguid VARCHAR(255),
    ModifiedDate DATETIME
);

CREATE TABLE special_offer_product (
    SpecialOfferID INT NOT NULL,
    ProductID INT NOT NULL,
    rowguid VARCHAR(255),
    ModifiedDate DATETIME,
    PRIMARY KEY (SpecialOfferID),
    FOREIGN KEY (ProductID)
        REFERENCES product (ProductID) on delete restrict
);

CREATE TABLE person (
    BusinessEntityID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    PersonType VARCHAR(60),
    NameStyle INT,
    Title VARCHAR(60),
    FirstName VARCHAR(60),
    MiddleName VARCHAR(60),
    LastName VARCHAR(60),
    Suffix VARCHAR(60),
    EmailPromotion VARCHAR(100),
    AdditionalContactInfo	 VARCHAR(100),
    Demographics VARCHAR(255),
    rowguid VARCHAR(255),
    ModifiedDate DATETIME
);

CREATE TABLE sales_order_header (
    SalesOrderID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    RevisionNumber INT,
    OrderDate DATETIME,
    DueDate DATETIME,
    ShipDate DATETIME,
    Status VARCHAR(60),
    OnlineOrderFlag INT,
    SalesOrderNumber VARCHAR(255),
    PurchaseOrderNumber VARCHAR(255),
    AccountNumber VARCHAR(255),
    CustomerID INT,
    SalesPersonID INT,
    TerritoryID INT,
    BillToAddressID INT,
    ShipToAddressID INT,
    ShipMethodID INT,
    CreditCardID INT,
    CreditCardApprovalCode VARCHAR(255),
    CurrencyRateID INT,
    SubTotal INT,
    TaxAmt INT,
    Freight INT,
    TotalDue INT,
    Comment VARCHAR(255),
    rowguid VARCHAR(255),
    ModifiedDate DATETIME
);

CREATE TABLE sales_order_detail (
    SalesOrderID INT NOT NULL,
    SalesOrderDetailID INT NOT NULL,
    CarrierTrackingNumber VARCHAR(255),
    OrderQty INT,
    ProductID INT,
    SpecialOfferID INT,
    UnitPrice DOUBLE(18 , 2),
    UnitPriceDiscount DOUBLE(18 , 2),
    LineTotal INT,
    rowguid VARCHAR(255),
    ModifiedDate DATETIME
);

CREATE TABLE customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    PersonID INT NOT NULL,
    StoreID INT NOT NULL,
    TerritoryID INT NOT NULL,
    AccountNumber VARCHAR(100),
    rowguid VARCHAR(255),
    ModifiedDate DATETIME
);


SELECT SalesOrderID as id, 
COUNT(*) AS qtd 
FROM sales_order_detail as sod
GROUP BY SalesOrderID
HAVING qtd >= 3
;

SELECT product.Name, SUM(sales_order_detail.OrderQty) as TotalQty, product.DaysToManufacture
FROM sales_order_detail
JOIN special_offer_product ON sales_order_detail.SpecialOfferID = special_offer_product.SpecialOfferID
JOIN product ON special_offer_product.ProductID = product.ProductID
GROUP BY product.DaysToManufacture, product.Name
ORDER BY TotalQty DESC
LIMIT 3;

SELECT product.ProductID, SUM(sales_order_detail.OrderQty) as TotalQty, sales_order_header.OrderDate
FROM sales_order_detail
JOIN sales_order_header ON sales_order_detail.SalesOrderID = sales_order_header.SalesOrderID
JOIN product ON sales_order_detail.ProductID = product.ProductID
GROUP BY product.ProductID, sales_order_header.OrderDate
ORDER BY sales_order_header.OrderDate;