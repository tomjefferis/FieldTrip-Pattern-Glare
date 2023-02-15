import pandas as pd

df = pd.DataFrame({'col1': [1, 2, 3]})
new_cols = ['col2', 'col3', 'col4']
df = df.reindex(columns=new_cols + df.columns.tolist(), fill_value=None)

df.head()