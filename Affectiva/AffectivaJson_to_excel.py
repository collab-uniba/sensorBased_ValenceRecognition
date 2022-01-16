#insert path json to analyze
import panda as pd 

df = pd.read_json('/Json_filename.json',lines=True)  
cols_to_keep = ['Timestamp','valence']  
 
#enter the path of the excel file on which the values ​​will be transcribed 
 
export_excel = df[cols_to_keep].to_excel(r'path_to_excel.xlsx', index = None, header=True) 