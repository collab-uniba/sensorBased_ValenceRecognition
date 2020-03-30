# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd

from os import walk
from os.path import join

tipo = "3labels" # Not_Neutral 3labels
filename = 1400
set = 80
while(filename<=7000) or (filename == 17710):
    FOLDER_PATH = r"/root/DanielaGrassi/Analysis/Results/" + "best_models_" + tipo + "_" + str(filename)  +"_" + str(set)
    print(FOLDER_PATH)
    files = []  
    for (dirpath, dirnames, filenames) in walk(FOLDER_PATH):
        files.extend(filenames)
        break
    files
    
    col_names = ['algorithm', 'macroPrecision', 'macroRecall', 'macroF1', 'accuracy']
    
    summary = pd.DataFrame(columns=col_names)
    
    csv_export_df = pd.DataFrame(columns=col_names)
    
    for file in files:
        print('FILE: ', file, end='\n\n')
        
        file_df = pd.DataFrame(columns=col_names)
        
        mylines = []                                
        with open(join(FOLDER_PATH, file), 'rt') as myfile:
            for myline in myfile: 
                mylines.append(myline.rstrip('\n'))
        
        counter = 0
        for ind, line in enumerate(mylines):
            if line.find("Metrics macro:") != -1:
                counter = counter + 1
                #print('Metrics '+ file + ' run ' + str(counter) + ':')
                
                raw_row_list = mylines[ind+3]
                row_list = [float(elem) for elem in raw_row_list.split( )[1:]]
                row_list = [file.rstrip('.txt')] + row_list
                row = dict(zip(col_names, row_list))
                
                file_df = file_df.append(row, ignore_index=True)
                
                #print(row)
        
        mean_row = file_df.mean()
        std_row = file_df.std()
        mean_row['algorithm'] = 'MEAN'
        std_row['algorithm'] = 'STD'
        file_df = file_df.append(mean_row, ignore_index=True)
        #file_df = file_df.append(std_row, ignore_index=True)
        
        # Prepare df for csv export
        csv_export_df = pd.concat([csv_export_df, file_df], ignore_index=True)
        
        
        # The df with mean measures for each algorithm
        summary_row = {
            'algorithm': file.rstrip('.txt'),
            'macroPrecision': mean_row['macroPrecision'],
            'macroRecall': mean_row['macroRecall'],
            'macroF1': mean_row['macroF1'],
            'accuracy': mean_row['accuracy']
        }
        summary = summary.append(summary_row, ignore_index=True)
        

    #print(file_df, end='\n\n')
            
                       
    summary.set_index('algorithm', inplace=True)
    summary
        
    csv_export_df.to_csv(r"/root/DanielaGrassi/Analysis/Results/" + "best_models_" + tipo + "_"+ str(filename)  +"_" + str(set) + "//" + "best_models_"+ tipo+ "_" + str(filename) +"_" + str(set) + ".csv", index=False)   
    filename = filename+ 1400
    if(filename == 17710):
        break
    if (filename==8400):
        filename=17710