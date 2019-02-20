 bin/spark-submit \
    --master k8s://https://192.170.227.132:6443 \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.kubernetes.namespace=ml-usatlas-org \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-acc \
    --conf spark.executor.instances=5 \
    --conf spark.kubernetes.container.image=slateci/spark:latest \
    https://raw.githubusercontent.com/slateci/spark/master/examples/src/main/python/pi.py
 