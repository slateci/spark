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


from pyspark.sql import SparkSession
from operator import add
from random import random

import os
os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3.5'
os.environ["PYSPARK_DRIVER_PYTHON"]='/usr/local/bin/ipython3'


spark = SparkSession\
    .builder\
    .appName("PythonPi")\
    .getOrCreate()

partitions = 2
n = 100000 * partitions


def f(_):
    x = random() * 2 - 1
    y = random() * 2 - 1
    return 1 if x ** 2 + y ** 2 <= 1 else 0


count = spark.sparkContext.parallelize(range(1, n + 1), partitions).map(f).reduce(add)
print("Pi is roughly %f" % (4.0 * count / n))

spark.stop()
