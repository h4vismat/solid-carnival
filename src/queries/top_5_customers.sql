SELECT
    customer_id
    ,total_revenue
FROM "AwsDataCatalog"."trusted"."customer_revenue"
WHERE partition_0 = '2024' AND partition_1 = '11' AND partition_2 = '13'
ORDER BY total_revenue DESC
LIMIT 5;
