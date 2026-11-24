Retail Sales SQL Assessment
About the project
This project is about analysing retail sales for October 2026. The dataset contains customer, store, product, order, order item and return details. The main aim is to compare sales across regions and understand how returns affect net sales.
Tool used
- DB Fiddle
- MySQL 8.0
Data cleaning
The region names were written in different formats, such as N and NORTH. I created a Regions table and mapped the stores to North, South and West.

Order item 5003 appeared twice. I kept the record with the latest LoadedAt value in OrderItems_Clean. The number of order lines reduced from 490 to 489. The original order lines were kept separately.

I also checked for unmatched customer IDs, customers without orders and order items with multiple returns. Orders with unmatched customer IDs were included in the sales analysis as required.
How to run
1. Open https://www.db-fiddle.com/ and select MySQL 8.0.
2. Copy the contents of sql/01_schema_and_all_records.sql into Schema SQL.
3. Copy sql/02_record_counts.sql into Query SQL and click Run to check the records.
4. Add the contents of sql/03_cleaning.sql at the end of Schema SQL. Do not remove the previous commands.
5. Run the queries in sql/04_question_queries.sql one by one in Query SQL.
Sales analysis
Gross sales were calculated using completed orders placed in October. Return values were calculated using returns processed in October, including returns from earlier orders. Net sales were calculated by subtracting the return value from gross sales.
Results
- Total gross sales: $42,757.75
- Total return value: $4,131.75
- Total net sales: $38,626.00
- North had the highest gross sales.
- South had the highest net sales, leading North by $210.
- Cedar Market had the highest net sales among the stores.
- Electronics had the highest return value in North.
Files included
- Completed assessment Word document
- SQL scripts in execution order
- DB Fiddle output screenshots
- ER diagram
- PowerPoint slide showing the main findings and recommendation