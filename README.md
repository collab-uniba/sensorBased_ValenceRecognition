# Sensor-Based Emotion Recognition in Software Development: Facial Expressions as Gold Standard

This package contains all the material used for the analysis presented in the paper "Sensor-Based Emotion Recognition in Software Development: Facial Expressions as Gold Standard"

  ### How to use the scripts

In the following, we provided a description of the folders contained in the replication package, as well as the instructions to run the scripts. 

Affectiva: This folder contains the scripts to manipulate the results produced by Affectiva.

- Discretization.R: Script to divide the valence values into three sets using k-means clustering

```bash
Rscript Descritazion.R <inputfile.json> <outputfile.xlsx>
```

- AffectivaJson_to_excel.py: Script to convert the output of Affectiva in a more readable csv format 
```bash
python AffectivaJson_to_excel.py
```

Dataset: this folder contains the scripts used to create the datasets

- createDataPartition.R: This script divides the dataset into training and testing. The input file of the dataset should be located in the same directory of the script. 

```bash
Rscript createDataPartition.R <input_filename.csv> <output_training_filename.csv> <output_testing_filename.csv>
```
- excludePolarity.R: This script modifies the original dataset by changing the labels from "neutral", "negative", "positive" to neutral", "not_neutral". The output dataset is the input for the training of the first classifier of the pipeline classifier. The input file of the dataset should be located in the same directory of the script. 

```bash
Rscript excludePolarity.R <input_filename.csv> <output_filename.csv>
```
- excludeNeutral.R: This script create a Dataset wihout the neutral case. The output dataset is the input for the training of the second classifier of the pipeline classifier. The input file of the dataset should be located in the same directory of the script. 
```bash
Rscript excludeNeutral.R <input_filename.csv> <output_filename.csv>
```
- selectNeutral.R: This script create a Dataset with different number of neutral case. The input file of the dataset should be located in the same directory of the script. 
```bash
Rscript selectNeutral.R <input_filename.csv> <output_filename.csv> <number_of_neutralcase_to_keep>
```

MachineLearning, contains the scripts to train and test classifier:

- Tuning_10k : Script to build and train the classifier with 10 fold cross validation

- Run_HoldOut_10k : is the Script to Run 10 times the script Tuning_10k; after that the result will be 10 model trained with ten fold cross validation 

```bash
nohup ./run_HoldOut_10k.sh <input.csv> models/models.txt <output_folder> <label> &> log.txt &
```
where, \<input> is the input dataset,  <output_folder> is the name of the folder where saving the output, \<label> is the class to classify (valence for example). 


- TestModel : is the script to Run the trained model on the test Dataset

```bash
Rscript testModel.R <input_test.csv> <best_model.rds> <prediction.csv> <result.csv>
```
  where, <input_test.csv> is the input  testing dataset,  <best_model.rds> is the best model trained with the command before, <result.csv> is the name of the file where saving the output metrics. 

 - PipelineSetting.R : this script use the model Neutral VS not Neutral to classifiy the test set into neutral or not neutral, then compute the metrics, select the best model and use it on the dataset Positive vs Negative to compute the predictions and the metrics. 

```bash
Rscript PipelineSetting.R <label> <testing_dataset_3labels.csv> <best_models_on_Neutral_vs_Non_Neutral.rds> <best_models_on_Positive_vs_Negative.rds> <predictions.csv> <metrics.csv> 
```
  where, \<label> is the input dataset,  <testing_dataset_3labels.csv> is the dataset of testing, <best_models_on_Neutral_vs_Non_Neutral.rds> is the best model that classify the samples in neutral and not_neutral <best_models_on_Positive_vs_Negative.rds> is the best model that classify the samples in positive and negative <predictions.csv> is the output file where there are the  classifier's predictions <metrics.csv> the output file with the metrics. 


- Results_Randomforest.xlsx contains the results obtained for each split (70/30, 80/20, 90/10) with the random forest algorithm. 
For each sheet there are three tables: the first table contains the results for each run (10 repetition 10 fold cross validation). 
The second table contains the results of the best model on the test set. 
The third table contains the mean of the performance of the 10 models trained with 10 fold cross validation 

- Results_SVM.xlsx contains the results obtained for each split (70/30, 80/20, 90/10) with the support vector machine algorithm. For each sheet  that regard the monolothic classifier there are three tables: The first table contains the results for each run (10 repetition 10 fold cross validation). The second table contains the results of the best model on the test set. 
The third table contains the mean of the performance of the 10 models trained with 10 fold cross validation 
For the sheet that regard the pipeline there is an additional table with respect to other sheets. 
This is because the first classifiers of the pipeline trained on unbalanced dataset report a recall equal to 1 on the majority class, so the second part of the pipeline training can't be completed. 
In conclusion, the first table contains the results for each run (10 repetition 10 fold cross validation); The second table contains the results of the best model on the test set (neutral vs not_neutral); The third table contains the mean of the metrics produced by all the 10 models trained with 10 fold cross validation; The fourth table contains the final metrics of the entire pipeline