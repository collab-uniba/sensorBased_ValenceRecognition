# enable commandline arguments from script launched using Rscript
#args<-commandArgs(TRUE)

# load libraries
library(caret)
library(mlbench)
library(randomForest)
library(doMC)
library(class)
# load dataset

tipo <- "3labels" # Not_Neutral 3labels

filename <- 1400
test <- 20
while(filename<=7000 || filename==17710) {
  
  input_dir <- paste("/root/DanielaGrassi/Analysis/Dataset/", tipo, "/", "Empatica", tipo, "_", 100-test, sep="")  
  input_file <- paste(input_dir,"/", "Test_", tipo, "_", filename, "Neu", "_", test, ".csv", sep="")             #CAMBIA Neu PER I 3 LABELS
  
  
  print(input_dir)
  testing <- read.csv(input_file, header = TRUE, sep=",")
  
  l<-ncol(testing)
  label <- testing[,l]
  
  
  excluded_predictors <- c("id", "valence")
  testing <- testing[ , !(names(testing) %in% excluded_predictors)]
  
  #print(testing[1:5,])
  
  # load the model

  #tipo2 <- "3Labels" #NotNeutral
  dir<- paste("/root/DanielaGrassi/Analysis/Results/best_models_", tipo, "_",filename, "_", 100-test, "/", "best_models_", tipo2, "_",filename, "_", 100-test, ".csv", sep="")
  df <- read.csv(dir)
  #modifica

df1 <- df[df$algorithm != "MEAN",]
excluded_predictors <- c("algorithm", "macroPrecision", "macroRecall")
results <- df1[ , !(names(df1) %in% excluded_predictors)]

acc <- scale(results$accuracy, center = TRUE, scale = TRUE)
f1 <- scale(results$macroF1, center = TRUE, scale = TRUE)
norma <- acc+f1
x <- max(norma)
c <- which(norma == x )
model <- paste("/root/DanielaGrassi/Analysis/Results/best_models_", tipo, "_", filename, "_", 100-test, "/models_rds/rf/", "best_model_", c, ".rds", sep="")  
 
  super_model <- readRDS(model)
  print(model)
  # make a predictions on "new data" using the final model
  final_predictions <- predict(super_model, testing)
  
  
  output_file <-paste("Result_model_test_",tipo, "_", filename, "_", 100-test, ".csv", sep="") 
  
  
  if(!exists("scalar_metrics", mode="function")) 
    source(paste(getwd(), "lib/scalar_metrics.R", sep="/"))
  scalar_metrics(predictions=final_predictions, truth=label, outdir= "ModelResults", output_file)
  
  final_predictions <- data.frame(final_predictions)
  
  output_file_predictions <- paste("Prediction_model_test_",tipo, "_", filename, "_", 100-test, ".csv", sep="") 
  write.csv(final_predictions,output_file_predictions, row.names = FALSE, quote = FALSE)
  
  rm(model)
  rm(final_predictions)
  # unload the package:
  lapply(names(sessionInfo()$loadedOnly), require, character.only = TRUE)
  invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE, unload=TRUE, force=TRUE))# garbage collection
  #gc()
  
  filename<- filename+1400

if(filename == 17710){
	break
	}

if(filename == 8400){
	filename=17710
	}
}
