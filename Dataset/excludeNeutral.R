
args <- commandArgs(TRUE)
current_dir <- getwd()

print(current_dir)

inputfile <- args[1]
outputfile <- args[2]

rows <- read.csv(paste(current_dir, inputfile, sep = "/"), header = TRUE)

n <-  c("neutral")
valid <- c("positive", "negative")

values <- rows[which(rows$valence %in% valid),]
write.table(values,paste(current_dir, outputfile, sep = "/"), row.names = FALSE, quote = FALSE, append = FALSE, sep = ",")

