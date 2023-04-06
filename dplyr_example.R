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

# Sample 20 individuals per pregnancy group and calculate
# the mean BMI & glucose per group.
preg_bmi_glucose <- tbl_diabetes %>% 
                      group_by(Pregnancies) %>% 
                      slice_sample(n = 20) %>%
                      summarise(
                        Count = n(), 
                        BMI = mean(BMI, na.rm = TRUE),
                        Glucose = mean(Glucose, na.rm = TRUE)) %>%
                      arrange(Pregnancies)

print(preg_bmi_glucose, n=20)

# We can peek into the SQL statement
preg_bmi_glucose %>%
  show_query()

# Disconnect from Spark
spark_disconnect(sc)