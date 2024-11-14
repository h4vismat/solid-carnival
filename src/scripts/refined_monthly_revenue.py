import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql import functions as F
from datetime import datetime

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'DEST_BUCKET', 'LAYER', 'DEST_FOLDER',
                                     'CATALOG_DATABASE', 'CATALOG_TABLE'])

DEST_BUCKET = args['DEST_BUCKET']
LAYER = args['LAYER']
DEST_FOLDER = args['DEST_FOLDER']
CATALOG_DATABASE = args['CATALOG_DATABASE']
CATALOG_TABLE = args['CATALOG_TABLE']

current_date = datetime.now()
current_year = current_date.year
current_month = current_date.month
current_day = current_date.day

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

dyf = glueContext.create_dynamic_frame.from_catalog(
        database=CATALOG_DATABASE,
        table_name=CATALOG_TABLE
        )

df = dyf.toDF()

df = df.withColumn("year_month", F.date_format(F.col("order_date"), "yyyy-MM")) \
                    .withColumn("total_order_price", F.col("quantity") * F.col("price"))
df = df.groupBy("year_month") \
        .agg(F.sum("total_order_price").alias("monthly_revenue"))

df.write.parquet(f"s3://{DEST_BUCKET}/{LAYER}/{DEST_FOLDER}/{current_year}/{current_month}/{current_day}")

job.commit()
