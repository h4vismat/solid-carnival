import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql import functions as F
from datetime import datetime

args = getResolvedOptions(sys.argv, ['JOB_NAME',
                                     'DEST_BUCKET',
                                     'LAYER',
                                     'DEST_FOLDER'])

DEST_BUCKET = args['DEST_BUCKET']
LAYER = args['LAYER']
DEST_FOLDER = args['DEST_FOLDER']

current_date = datetime.now()
current_year = current_date.year
current_month = current_date.month
current_day = current_date.day

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

df = spark.read.options(delimiter=',', header=True).csv(f"s3://{DEST_BUCKET}/10_landing/orders/")

df = df.withColumnRenamed("order_date;;;;;;;", "order_date") \
        .withColumn("order_date", F.regexp_replace("order_date", ";", ""))

df = df.withColumn("quantity", F.col("quantity").cast("int")) \
        .withColumn("price", F.col("price").cast("float")) \
        .withColumn("order_date", F.to_date(F.col("order_date"), "yyyy-MM-dd"))

df.write.mode("overwrite").parquet(f"s3://{DEST_BUCKET}/{LAYER}/{DEST_FOLDER}/{current_year}/{current_month}/{current_day}")

job.commit()
