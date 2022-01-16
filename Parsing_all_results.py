# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd

from os import walk
from os.path import join
filename = 2800
set = 80
tipo = "3labels"
while(filename<=7000) or (filename == 17710):
    FOLDER_PATH = r"\root\Analysis\Results_" + str(set) + "\\best_models_" + tipo + "_" + str(filename)  + "_" + str(set)
    df1 = pd.read_csv(FOLDER_PATH + "\\best_models_" + tipo + "_" + str(filename)  + "_" + str(set)+ ".csv", header=0)
    
    print(FOLDER_PATH)
    files = []  
    for (dirpath, dirnames, filenames) in walk(FOLDER_PATH):
        files.extend(filenames)
        break
    files
    
    col_names = [ 'name','precision', 'macroRecall', 'f1']
    
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
            if line.find("Metrics per class:") != -1:
                counter = counter + 1
                print('Metrics '+ file + ' run ' + str(counter) + ':')
                
                raw_row_list = mylines[ind+3]

                row_list = [float(elem) for elem in raw_row_list.split( )[1:]]
                row_list = [raw_row_list.split( )[0]] + row_list
                row = dict(zip(col_names, row_list))
    
                file_df = file_df.append(row, ignore_index=True)
                
                raw_row_list = mylines[ind+4]
     
                row_list = [float(elem) for elem in raw_row_list.split( )[1:]]
                row_list = [raw_row_list.split( )[0]] + row_list
                row = dict(zip(col_names, row_list))
         
                file_df = file_df.append(row, ignore_index=True)
                
                raw_row_list = mylines[ind+5]
      
                row_list = [float(elem) for elem in raw_row_list.split( )[1:]]
                row_list = [raw_row_list.split( )[0]] + row_list
                row = dict(zip(col_names, row_list))
                
                file_df = file_df.append(row, ignore_index=True)
                
                del file_df['macroRecall']
                
                
                df1 = df1.dropna(axis=0, how='any', thresh=None, subset=None, inplace=False)
                #print(df1)
        
                file_df = file_df.rolling(3).mean()

                file_df = file_df.dropna(axis=0, how='any', thresh=None, subset=None, inplace=False)
                #csv_export_df = pd.concat([file_df], ignore_index=True)
                print(df1)
                # file_df= file_df[file_df.name != 'neutral']
                # file_df= file_df[file_df.name != 'positive'] 
                # file_df= file_df[file_df.name != 'negative'] 
                print(df1)
                print(file_df)
                combined = df1.combine_first(file_df)
                combined = file_df.merge(combined, on = 'precision')
                del combined['macroPrecision']
                del combined['macroF1']
                del combined['f1_y']
                combined.rename(columns={'f1_x':'macroF1',
                          'precision':'macroPrecision',
                          }, 
                 inplace=True)
                csv_export_df = pd.concat([combined], ignore_index=True)

        
    csv_export_df.to_csv(r"\\root\\Analysis\\Results_" + str(set) + "\\" + "best_models_" + tipo + "_" + str(filename) +"_" + str(set) + "//" + "manipolazione"  + tipo + "_" + str(filename) +"_" + str(set) + ".csv", index=False)   
   
    filename = filename +1400
    if(filename == 17710):
        break
    if (filename==8400):
        filename=17710

