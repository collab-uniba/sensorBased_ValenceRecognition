
args <- commandArgs(TRUE)
current_dir <- getwd()

output_dir <- current_dir
input_dir <- current_dir
input_filename <- args[1]
outputfile <- args[2]
nNeutral <- args[3]

rows <- read.csv(input_filename)
n<-  c('neutral')
valid <- c('positive', 'negative')

neutral<- rows[which(rows$valence %in% n),]
neutral <- neutral[sample(1:nrow(neutral), nNeutral),]

values <- rows[which(rows$valence %in% valid),]
values <- rbind(values, neutral)

values <- values[order(as.numeric(rownames(values))),]
values <- data.frame(values)

write.table(values, paste(output_dir, outputfile, sep = "/"), row.names = FALSE, quote = FALSE, append = FALSE, sep = ",")

