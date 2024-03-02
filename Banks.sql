create table Assets_Liabilities (
Cert INT,
Report_Period DATE,
Institution_Name VARCHAR(300),
City VARCHAR(50),
State VARCHAR(10),
Class VARCHAR(10),
Total_Assets FLOAT,
Total_Deposits FLOAT
);

Select * from assets_liabilities;

create table FailedBankList (
CERT INT,
Bank_Name VARCHAR(300),
City VARCHAR (50),
ST VARCHAR (10),
Acquiring_Institution VARCHAR(300),
Closing_Date DATE,
Updated_Date DATE
);

Select * from FailedBankList;

create TABLE Locations (
CERT INT,
STNAME VARCHAR(50),
DOCKET INT,
ACTIVE INT,
ADDRESS	VARCHAR(300),
ASSET FLOAT,
CITY VARCHAR(50),
COUNTY VARCHAR(50),
DEP	FLOAT,
INACTIVE INT,
NAME VARCHAR(300),
NEWCERT INT,
ROA	FLOAT,
ROAQ FLOAT,
ROE	FLOAT,
ROEQ FLOAT,
ZIP INT
)

select * from locations;

CREATE TABLE All_BANKS(
CERT INT,
STNAME VARCHAR(50),
DOCKET INT,
ACTIVE INT,
ADDRESS	VARCHAR(300),
BKCLASS	VARCHAR(10),
CHRTAGNT VARCHAR(10),
CITY VARCHAR(50),
COUNTY VARCHAR(50),
DEP FLOAT,
ASSET FLOAT
)

-- CALCULATE LOAN TO DEPOSIT (LDR) RATIO BY THIS FORMULA (LDR= TOTAL LOANS/TOTAL DEPOSITS)

SELECT * FROM assets_liabilities;

SELECT cert, institution_name,state, total_assets,total_deposits from assets_liabilities;
----- ?????????????

-- HOW MANY DISTINCT BANKS ARE IN THE DATABASE?

SELECT * FROM locations;

SELECT COUNT (DISTINCT name) from locations;


--- Find the names & ROE of the banks from New York which are still active?

SELECT name, ROE from Locations where STNAME = 'New York' AND ACTIVE = 1;

--- Find the exceptional active banks with ROA >= 100 &/ ROE >1000

SELECT name from locations
where ROA >= 100 AND ROE >1000 AND active = 1;

SELECT name from locations
where ROA >= 100 OR ROE >1000 AND active != 0;

--- What are the top Banks with highest total assets in the list, anywhere outside of NY State?
select * from assets_liabilities
where state != 'NY'
ORDER BY total_assets DESC
LIMIT 5;

-- Please show the list of Banks which faced banksuptcy during the 2008
-- financial crisis period of 2008-2010.

SELECT DISTINCT(Bank_Name) from failedbanklist
where closing_date BETWEEN '2008-01-01' AND '2010-12-31';

--- Find out how many insured banks from FDIC all banks lists are from top 4 largest States by economy?

SELECT COUNT (CERT) from all_banks
where STNAME IN ('California', 'Texas', 'New York', 'Florida');

-- Find the names of the Banks in the bankruptcy list where failed banks does not contain
-- Community in their names & acquiring Banks start exactly with "No Acquirer"

Select * from failedbanklist
where Bank_Name ILIKE '%Community%' AND Acquiring_Institution LIKE 'No Acquirer%';

-- List the states with over 50 Bankruptcy events 

Select * from failedbanklist;
SELECT ST, COUNT(CERT) from failedbanklist
GROUP BY ST
HAVING COUNT(CERT)>50;

-- Find out if there is Any current info regarding Assets & Deposits for all failed banks using INNER JOIN:

SELECT Total_Assets, Total_Deposits, Assets_Liabilities.CERT, Institution_Name
from Assets_Liabilities
INNER JOIN FailedBankList
ON Assets_Liabilities.CERT = FailedBankList.CERT;




---------------------------------------- RENAME the columns correctly 
--- in all tables to create relationship within tables

Select * from all_banks; 
Select * from failedbanklist;
Select * from locations;
Select * from assets_liabilities;
--- RENAMING SAME COLUMNS THE SAME IN EVERY TABLE
ALTER TABLE locations 
RENAME COLUMN stname TO ST;
ALTER TABLE locations 
RENAME COLUMN asset to assets
ALTER TABLE locations
RENAME COLUMN dep TO deposits;
ALTER TABLE assets_liabilities
RENAME COLUMN institution_name to name;
ALTER TABLE assets_liabilities
RENAME COLUMN state TO st;
ALTER TABLE assets_liabilities
RENAME COLUMN total_assets to assets;
ALTER TABLE assets_liabilities
RENAME COLUMN total_deposits to deposits;
ALTER TABLE failedbanklist
RENAME COLUMN bank_name to name;
ALTER TABLE all_banks
RENAME COLUMN stname to ST;
Select * from all_banks; 
ALTER TABLE all_banks
RENAME COLUMN dep to deposits;
ALTER TABLE all_banks
RENAME COLUMN asset to assets;
----------------------------------------


--- Find the all the addresses & total deposits of companies who are both unique 
-- in locations table & assets & liabilities table

SELECT locations.name, address, locations.deposits from locations
FULL OUTER JOIN assets_liabilities
ON locations.cert = assets_liabilities.cert
WHERE locations.cert IS null OR assets_liabilities.cert IS null;


--- Compare the table all_banks & failedbanklist & find the names
---- unique to only failedbanklist

SELECT name from all_banks
RIGHT JOIN failedbanklist ON
all_banks.cert = failedbanklist.cert
WHERE all_banks.cert IS null;

--- Show full addresses in one line of all banks
SELECT * from locations;
SELECT LENGTH (name) FROM locations;
SELECT address || ',' ||city || ',' ||county || ',' ||st || '-' || zip || '.'
from locations
WHERE deposits >= 10000000;