filename <- "10seconds_3labels_testing_arousal_pol.csv"

inputfile <- "/root/DanielaGrassi/Analysis/Dataset_pipeline/10seconds/10seconds_3labels_testing_arousal.csv"
outputfile <- "/root/DanielaGrassi/Analysis/Dataset_pipeline/10seconds/10seconds_3labels_testing_arousal_pol.csv"

rows <- read.csv(inputfile, header = TRUE)

#rows <- read.csv(paste((paste(getwd(), "_3labels", sep = "/")), filename, sep = "/"))

n <-  c("neutral")

valid <- c("low", "high")


neutral <- rows[which(rows$arousal %in% n),]
print(neutral)


#neutral <- neutral[sample(1:nrow(neutral), 50),]

values <- rows[which(rows$arousal %in% valid),]

write.table(values,outputfile, row.names = FALSE, quote = FALSE, append = FALSE, sep = ",")


#values <- rows[which(rows$Label %in% valid & sample(rows$Label %in% V, 100)),]

#values <- rbind(values, neutral)

values <- values[order(as.numeric(rownames(values))),]
values <- data.frame(values)
output_dir <- "/root/DanielaGrassi/Analysis/Dataset_pipeline/10seconds"

write.table(values, paste(output_dir, filename, sep = "/"), row.names = FALSE, quote = FALSE, append = FALSE, sep = ",")

