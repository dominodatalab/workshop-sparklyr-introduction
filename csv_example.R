library(sparklyr)
library(dbplot)

# Connect to Spark
master <- paste(Sys.getenv("SPARK_MASTER_HOST"), Sys.getenv("SPARK_MASTER_PORT"), sep = ":")
url <- paste("spark://", master, sep = "")
sc <- spark_connect(master=url, app_name="HelloWorld")

# Read into Spark
# Construct the absolute path to the dataset
project_name <- Sys.getenv("DOMINO_PROJECT_NAME")
data_file_location <- paste("file:///mnt/data/", project_name, "/diabetes.csv", sep = "")
# Read into Spark
tbl_diabetes <- spark_read_csv(sc, name = "diabetes", path=data_file_location)
# Show the first 6 entries
head(tbl_diabetes)

dbplot_histogram(tbl_diabetes, Age)

# Disconnect from Spark
spark_disconnect(sc)