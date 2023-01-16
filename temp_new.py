import numpy as np
import pandas as pd
import streamlit as st
from pandas_profiling import ProfileReport
from streamlit_pandas_profiling import st_profile_report

# Web App Title
global df,df1,df2
#92                
    
def main():
    st.title("File Upload & Save File to Dicrectory App")
    st.markdown('''
    # **The EDA App**
    This is the **EDA App** created in Streamlit using the **pandas-profiling** library.
    
    ''')
    menu = ["Single_Dataset_Uploader","Multiple_Dataset_Uploader","About"]
    choice = st.sidebar.selectbox("Menu",menu)
    
    # Upload CSV data
    
    if choice == "Single_Dataset_Uploader":
        st.sidebar.header('1. Upload your files here')
        
        uploaded_file_single = st.sidebar.file_uploader("Upload your input file", type = ['csv', 'xlsx','xls'])

    
    # Pandas Profiling Report
        if uploaded_file_single is not None and choice == "Single_Dataset_Uploader":      
            if st.button("Process"):

                file_details = {"Filename":uploaded_file_single.name,"FileType":uploaded_file_single.type,"FileSize":uploaded_file_single.size}
                st.write(file_details)

                try:
                    df = pd.read_csv(uploaded_file_single ) 
                except Exception as e:
                    print(e)
                    df = pd.read_excel(uploaded_file_single,engine='openpyxl' )
                st.header('**Input DataFrame for single**')
                st.dataframe(df)            

                st.write('---')
                if st.button("pandas profiling"):
                    st.dataframe(df)
                    pr1 = ProfileReport(df, explorative=True)
                    st.header('**Pandas Profiling Report**')
                    st_profile_report(pr1)
                
    elif choice == "Multiple_Dataset_Uploader":
        
        st.sidebar.header('1. Upload your files here')
        uploaded_file = st.sidebar.file_uploader("Upload your input file", type = ['csv', 'xlsx','xls'])
        merge_file = st.sidebar.file_uploader("Upload your 2nd input file",type = ['csv', 'xlsx','xls'])
        if merge_file and uploaded_file is not None and choice == "Multiple_Dataset_Uploader":
            if st.button("Process"):

                file_details_m1 = {"Filename":uploaded_file.name,"FileType":uploaded_file.type,"FileSize":uploaded_file.size}
                st.write(file_details_m1)

                try:
                    df1 = pd.read_csv(uploaded_file, low_memory = False ) 
                except Exception as e:
                    print(e)
                    df1 = pd.read_excel(uploaded_file,engine='openpyxl' )
                st.header('**Input DataFrame for first file**')
                st.dataframe(df1)            

                st.write('---')
                file_details_m2 = {"Filename":merge_file.name,"FileType":merge_file.type,"FileSize":merge_file.size}
                st.write(file_details_m2)
                try:
                    df2 = pd.read_csv(merge_file,low_memory = False ) 
                except Exception as e1:
                    print(e1)
                    df2 = pd.read_excel(merge_file,engine ='openpyxl' )
                st.header('**Input DataFrame for second file**')
                st.write(df2)            

                st.write('---')

                if df1 and df2 is not None:
                    if st.button("Click to select column"):

                        option1 = st.selectbox('Which column to connect from Table 1 ?',options = set(list(df1.columns)))
            
                        option2 = st.selectbox('Which column to connect from Table 2 ?',options = set(list(df2.columns)))


                
                        if st.button("Click to merge"):
                            data = pd.merge(df1,df2,how = 'outer',left_on = option1,right_on = option2)
                            st.write(data)
                            pr2 = ProfileReport(data, explorative=True)
                            st.header('**Pandas Profiling Report**')
                            st_profile_report(pr2)            
                               

    
if st.button('Press to use Example Dataset'):
    st.info('Awaiting for file to be uploaded.')
        
                # Example data
    
    def load_data():
        a = pd.DataFrame(
            np.random.rand(100, 5),
            columns=['a', 'b', 'c', 'd', 'e']
        )
        return a
    df3 = load_data()
    pr3 = ProfileReport(df3, explorative=True)
    st.header('**Input DataFrame auto**')
    st.write(df3)
    st.write('---')
    st.header('**Pandas Profiling Report**')
    st_profile_report(pr3)

if __name__ == '__main__':
    main()