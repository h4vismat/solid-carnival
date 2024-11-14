import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from delta.tables import *

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'CATALOG_DATABASE', 'CATALOG_TABLE', 'DEST_BUCKET', 'LAYER', 'DEST_FOLDER'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

CATALOG_DATABASE = args['CATALOG_DATABASE']
CATALOG_TABLE = args['CATALOG_TABLE']
DEST_BUCKET = args['DEST_BUCKET']
LAYER = args['LAYER']
DEST_FOLDER = args['DEST_FOLDER']

dyf = glueContext.create_dynamic_frame.from_catalog(
    database=CATALOG_DATABASE,
    table_name=CATALOG_TABLE
)

df = dyf.toDF()

df.write.format("delta").mode("overwrite").save(f"s3://{DEST_BUCKET}/{LAYER}/{DEST_FOLDER}/")

job.commit()
