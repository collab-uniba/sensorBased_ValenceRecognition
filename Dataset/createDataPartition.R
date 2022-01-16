
#This script takes in input the dataset file and split it in training and tasting given a 


library(caret)
args <- commandArgs(TRUE)
current_dir <- getwd()

print(current_dir)

input_file <- args[1]
output_train <- args[2]
output_test <- args[3]

dataset <-
  read.csv(paste(current_dir, input_file , sep = "//"),
           header = TRUE,
           sep = ",")


#change parameter p to create different settings of train and test (70-30; 80-20; 90-10)
splitIndex <-
  createDataPartition(dataset[, "valence"], p = .90, list = FALSE)
training <- dataset[splitIndex,]
testing <- dataset[-splitIndex,]

write.table(
  training,
  paste(current_dir, output_train, sep = "/"),
  row.names = FALSE,
  quote = FALSE,
  append = FALSE,
  sep = ","
)
write.table(
  testing,
  paste(current_dir, output_test, sep = "/"),
  row.names = FALSE,
  quote = FALSE,
  append = FALSE,
  sep = ","
)

#commands that can be used to create dataset excluding neutral
#valid <- c('positive', 'negative')
#training_noNeutral <- training[which(training$valence %in% valid),]
#testing_noNeutral <- testing[which(testing$valence %in% valid),]
#use write table for creating the files for training_noNeutral and testing_noNeutral
