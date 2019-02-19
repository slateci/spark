from pyspark import SparkConf, SparkContext
from pyspark import SparkFiles
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext


conf = SparkConf().setAppName('IlijaTest').setMaster('spark://spark-master:7077')
sc = SparkContext(conf=conf)

NUM_SAMPLES = 3000000

def inside(p):
    x, y = random.random(), random.random()
    return x * x + y * y < 1

count = sc.parallelize(range(0, NUM_SAMPLES)).filter(inside).count()
print("Pi is roughly ",  (4.0 * count / NUM_SAMPLES))
