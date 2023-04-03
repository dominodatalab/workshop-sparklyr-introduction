library(sparklyr)

# Connect to Spark
master <- paste(Sys.getenv("SPARK_MASTER_HOST"), Sys.getenv("SPARK_MASTER_PORT"), sep = ":")
url <- paste("spark://", master, sep = "")
sc <- spark_connect(master=url, app_name="HelloWorld")

# Copy mtcars into Apache Spark
tbl_mtcars <- copy_to(sc, mtcars, "spark_mtcars")

# Read from the Spark DataFrame
print(tbl_mtcars)

# Disconnect from Spark
spark_disconnect(sc)