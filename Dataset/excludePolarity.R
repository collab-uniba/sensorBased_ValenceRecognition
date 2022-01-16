
args <- commandArgs(TRUE)
current_dir <- getwd()

input_file <- current_dir
filename <- args[1]
outputfile <- args[2]


output_dir <- "/Empatica_Not_Neutral"
dir.create(file.path(input_file, output_dir), showWarnings = FALSE)
output_dir <- paste(current_dir, output_dir, sep="\\")


if (file.exists(paste(input_file,filename , sep = "\\"))) {
  rows <- read.csv(paste(input_file,filename , sep = "\\"), header = TRUE, sep=",")
  
  levels(rows$valence) <- c(levels(rows$valence), "not_neutral") 
  levels(rows$valence)  
  rows$valence[rows$valence == "neutral"] <- 'neutral'
  
  rows$valence[rows$valence == "positive"] <- 'not_neutral'
  rows$valence[rows$valence == "negative"] <- 'not_neutral'
  
  
  output_file <- paste(output_dir, outputfile, sep = "/")
  print(output_file)
  write.table(rows, output_file, row.names = FALSE, quote = FALSE, append = FALSE, sep = ",")
  
}
  
