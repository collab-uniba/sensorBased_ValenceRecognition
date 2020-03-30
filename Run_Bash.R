setwd("/root/DanielaGrassi/Analysis")
input_dir <- "//root//DanielaGrassi//Analysis//Dataset//3labels//Empatica3labels_80//"
#input_dir <- "/root//DanielaGrassi//Analysis//Dataset//Not_Neutral//EmpaticaNot_Neutral_80//"
x <- "/root/DanielaGrassi/Analysis/run_HoldOut_10k.sh" #my bash file which i want to run in r

filename <- 1400
set <- 80
tipo <- "3labels" # Not_Neutral
repeat {
  # Eliminare "Neu_" per i not_neutral 
  input_file <- paste(input_dir, "Train", "_", tipo , "_",  filename, "Neu_", set, ".csv", sep="")
  output_file <- paste("best_models_", tipo, "_", filename,"_", set, ".txt", sep="")
  output_dir <-  paste("Results//best_models_", tipo, "_", filename,"_", set , sep="")
  print(input_file)
  print(output_file)
  print(output_dir)
  if (file.exists(input_file)) { 
    stdInput <- paste(input_file, "models/rf.txt", output_dir, "valence", output_file)
    
    
    
    system2(x, args= stdInput, wait = TRUE)
    
    filename <- filename +1400
    
    if (filename == 17710)  { 
      break
    }
    
    if(filename == 8400){
      filename =17710
    }
    
  }
  
}
