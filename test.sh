/opt/spark/bin/spark-submit \
   --master k8s://https://192.170.227.132:6443 \
   --conf spark.kubernetes.namespace=ml-usatlas-org \
   --conf spark.kubernetes.container.image=slateci/spark:latest \
   --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-acc \
   --conf spark.executor.instances=5 \
   --deploy-mode cluster \
   --name spark-pi-1 \
   https://raw.githubusercontent.com/slateci/spark/master/examples/src/main/python/pi.py