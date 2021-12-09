# sensorBased_ValenceRecognition
Valence recognition based on Empatica E4 using Affectiva scores as gold label 

Input_for_pipeline.R : script to it's a script that remove all the Neutral Samples from the dataset, and create a new dataset, which will be the input dataset for the pipeline classifier 

Tuning_10k_Train : Script to build and train the classifier with 10 fold cross validation

Run_HoldOut_10k : is the Script to Run 10 times the script Tuning_10k_Train; after that the result will be 10 model trained with ten fold cross validation 

 The command to run this script is:

```bash
nohup ./run_HoldOut.sh <input.csv> models/models.txt <output_folder> <label> &> log.txt &
```

For example if you want to train a three label classifier:

```bash
nohup ./run_HoldOut_10k.sh Train_Polarity_90.csv models/svm.txt results_Polarity_90 valence best_models_polarity_90.txt &>Trainpol90.txt &
```

TestModel : is the script to Run the trained model on the test Dataset

The command will be 

```bash
Rscript testModel.R <input_test.csv> <best_model.rds> <prediction.csv> <result.csv>
```

For example if we want to run this command: 

```bash
Rscript testModel.R Test_30.csv /root/DanielaGrassi/Analysis/results_70/models_rds/rf/best_model_5.rds prediction_model_70.csv result_model_70.csv
```

PipelineSetting.R : this script use the model Neutral VS not Neutral to classifiy the test set into neutral or not neutral, then compute the metrics, select the best and use it on the dataset Positive vs Negative to compute the predictions and the metrics. 

```bash
Rscript PipelineSetting.R <label> <testing_dataset_3labels.csv> <best_models_on_Neutral_vs_Non_Neutral.rds> <best_models_on_Positive_vs_Negative.rds> <predictions.csv> <metrics.csv> 
```
