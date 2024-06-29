# general step: print out the following: table_name, row_count


#import the required python packages
import duckdb


#2.0 - Creawte DuckDB connection:
connection = duckdb.connect('cmu_95797_data_warehousing_project.db')
cursor = connection.cursor()


#view your tables
result = connection.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = result.fetchall()


for i in range(len(tables)):
    table_name = tables[i][0]
    query_text = "SELECT count(*) FROM " + table_name   #create SQL query to run against database
    result_of_query = connection.execute(query_text)    #execute SQL query against database and grab result object
    result_of_query_list = result_of_query.fetchall()   #convert result object into list of "rows"
    result_num_rows = result_of_query_list[0][0]        #grab the value output from the count
    print(table_name + ": " + str(result_num_rows) + ' rows')   #print the table name and the number of rows


