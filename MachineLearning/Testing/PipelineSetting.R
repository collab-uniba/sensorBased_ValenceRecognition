# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

library(caret)
#library(mlbench)
#library(randomForest)
#library(doMC)
#library(class)
source("lib/scalar_metrics.R")

labelname <- args[1] #transform is as input parameter
test_3labels <- args[2] #paste(getwd(), "Dataset/Dataset_pipeline/10seconds/10seconds_3labels_testing_valence.csv",sep="/")
test_set <- read.csv(test_3labels)

outdir <- paste(getwd(), "Results/", sep = "/")
if(!dir.exists(outdir))
  dir.create(outdir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

output_file_metrics <- paste(outdir, args[6], sep ="/")


#param 1: labelName
#param 2: test set
#param 3: model neu non neu
#param 4: model polarity
#param 5: output file predictions
#param 6: output file metrics


#step 1: use the model Neutral VS not Neutral to classifiy the test set into neutral or not neutral
model_NeuNotNeu <- paste(getwd(), args[3], sep = "/") #transform it as input parameter

super_model_NeuNotNeu <- readRDS(model_NeuNotNeu)
predictions <- predict(super_model_NeuNotNeu, test_set[,2:13])
predictions_notNeutral <- predictions


label_neutral <- as.character(test_set[,labelname],  stringsAsFactors = FALSE)
if(labelname=="arousal"){
    label_neutral <- replace(label_neutral, label_neutral=="high", "not_neutral")
    label_neutral <- replace(label_neutral, label_neutral=="low", "not_neutral")
}else{
    label_neutral <- replace(label_neutral, label_neutral=="positive", "not_neutral")
    label_neutral <- replace(label_neutral, label_neutral=="negative", "not_neutral")
}
scalar_metrics(predictions=predictions_notNeutral, truth=label_neutral, outdir , output_file_metrics)


#step 2: create dataframe from cases predicted as not_neutral

new_dataset <- cbind(test_set, predictions)

dataset_notNeutral<- new_dataset[new_dataset$predictions!="neutral",]

#step 3: use the POLARITY model on the dataset composed only by not neutral cases

labels_polarity<- dataset_notNeutral[dataset_notNeutral$predictions!="neutral", "valence"]
model_polarity <- paste(getwd(), args[4], sep = "/") #polarity model here! #transform it as input parameter

super_model_polarity <- readRDS(model_polarity)

# make a predictions on "new data" using the final model
#excluding columnns: id, valence, arousal, final_predictions
final_predictions_polarity <- predict(super_model_polarity, dataset_notNeutral[,2:13])

#scalar_metrics(predictions=final_predictions_polarity, truth=labels_polarity, outdir = paste(getwd(), "results/", sep = "/"), output_file_metrics)


#step 4: recompose the dataset with the neutral and polarity predictions and compute the metrics

ids <- test_set[,"id"]
label <- test_set[, labelname]

#merge not neutral predictions with polarity predictions
final_predictions <- c()
j<-1

for(i in 1:length(predictions_notNeutral)){
  valence_predicted <- predictions_notNeutral[i]
  if(valence_predicted == "not_neutral"){
    valence_predicted <- final_predictions_polarity[j]
    #print(paste("j ", j))
    # print(paste("valence", valence_predicted))
    j <- j+1
  }
  final_predictions <- c(final_predictions, as.character(valence_predicted))
  valence_predicted <-""
}

output_file_predictions <- paste(outdir, args[5], sep ="/") #set this as input parameter
df_predictions_pipeline <- data.frame(ids, label,final_predictions)
write.table(df_predictions_pipeline,output_file_predictions, row.names = FALSE, quote = FALSE, append = FALSE, sep = ",")


scalar_metrics(predictions=final_predictions, truth=label, outdir , output_file_metrics)
