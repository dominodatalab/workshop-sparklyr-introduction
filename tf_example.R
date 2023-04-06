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
tbl_diabetes <- spark_read_csv(sc, name = "diabetes", path=data_file_location) %>% 
                ft_one_hot_encoder(input_cols="Pregnancies",
                                   output_cols="Pregnancies_enc") %>%
                ft_vector_assembler(input_cols = c("Pregnancies", "Glucose", "BMI", "BloodPressure", "SkinThickness", "Insulin", "Age", "DiabetesPedigreeFunction"), 
                                    output_col = "features") %>%
                ft_standard_scaler(  input_col = "features",
                                     output_col = "features_scaled") %>%
                select(features, Outcome)

samp <- tbl_diabetes %>% sdf_sample(fraction = .01) %>% collect()

# Disconnect from Spark
spark_disconnect(sc)