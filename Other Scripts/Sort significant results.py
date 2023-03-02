import pandas as pd
import os

def sort_significant_results(df, p_value=0.05):
    """
    Sort the significant results in a pandas DataFrame.

    Parameters
    ----------
    df : pandas.DataFrame
        The DataFrame to sort.
    p_value : float, optional
        The p-value threshold to filter the results. The default is 0.05.

    Returns
    -------
    pandas.DataFrame
        The sorted DataFrame.

    """
    # Filter the rows with a specific value in a column
    filtered_table = df[(df['Positive_Cluster'] < p_value) | (df['Negative_Cluster'] < p_value)]



    return filtered_table

def append_string(s, suffix):
    return s + ' ' + suffix

file_dir = '/Users/tomjefferis/Documents/PhD/Pattern-Glare-Data/Results/frequency/stat_results/'
concat_dir = []
for file in os.listdir(file_dir):
    if file.endswith('.xls') or file.endswith('.xlsx'):
        df = pd.read_excel(file_dir + file)
        df['Factor_Name'] = df['Factor_Name'].apply(append_string, suffix=file[:-5])
        df = sort_significant_results(df)
        concat_dir.append(df)


concat_dir = pd.concat(concat_dir)
concat_dir.to_excel('/Users/tomjefferis/Documents/PhD/Pattern-Glare-Data/Results/frequency/significant_clusters.xlsx')
