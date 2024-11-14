SELECT
	product_id
	,quantity_sold
FROM "AwsDataCatalog"."trusted"."product_sales"
WHERE partition_0 = '2024' AND partition_1 = '11' AND partition_2 = '13'
ORDER BY quantity_sold DESC
LIMIT 5;
