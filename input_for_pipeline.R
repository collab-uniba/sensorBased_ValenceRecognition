

input_3labels <- "/root/DanielaGrassi/Analysis/Dataset_pipeline/10seconds"
input_notNeutral <- "/root/DanielaGrassi/Analysis/"



#nNeutral <- 1400
#repeat {
    output_dir <- "/root/DanielaGrassi/Analysis/new_dataset"
    
    pattern_pred <- glob2rx(paste("*predictions_10seconds_NeuVSnotNeu_valence_rf*")) #nNeutral
    pattern_test <- glob2rx(paste("*10seconds_3labels_testing_valence*"))
    
    
    filename_pred <- list.files(path=input_notNeutral, pattern=pattern_pred)
    p <- paste(input_notNeutral,filename_pred, sep="/" )
    prediction_notNuetral <- read.csv(p)
    print(paste(input_notNeutral,filename_pred, sep="/" ))
   
    filename_test <- list.files(path=input_3labels, pattern=pattern_test)
    print(paste(input_3labels,filename_test, sep="/" ))
	t <-paste(input_3labels,filename_test, sep="/" )
    test_3labels <- read.csv(t)
    
    new_dataset <- cbind(test_3labels, prediction_notNuetral)

    new_dataset <- new_dataset[new_dataset$final_predictions!="neutral",]
    
    output_dir<- paste(output_dir, "/new_dataset_forPipeline_10seconds_valence", ".csv", sep="")
    write.csv(new_dataset, output_dir)
  
  #  nNeutral <- nNeutral +1400
  
 # if (nNeutral == 17710)  { 
 #   break
 # }
  
 # if(nNeutral == 8400){
 #   nNeutral =17710
 # }
  
#}

