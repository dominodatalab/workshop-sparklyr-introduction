library(sparklyr)
library(dplyr)

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

# Count the number of rows
count(tbl_diabetes)

# Sample and plot Age vs BMI
select(tbl_diabetes, Age, BMI) %>%
  sample_n(200) %>%
  collect() %>%
  plot()

# Disconnect from Spark
spark_disconnect(sc)