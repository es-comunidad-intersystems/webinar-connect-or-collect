import os
import streamlit as st
import psycopg2
import pandas as pd

# Database connection parameters from environment variables
DB_HOST = os.getenv('DB_HOST', 'db')
DB_NAME = os.getenv('DB_NAME', 'Favorita')
DB_USER = os.getenv('DB_USER', 'myuser')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'mypassword')
DB_PORT = os.getenv('DB_PORT', '5432')


# Function to get a database connection
def get_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return conn

# Function to fetch data from the table
def fetch_data():
    conn = get_connection()
    df = pd.read_sql("SELECT * FROM mytable ORDER BY id ASC", conn)
    conn.close()
    return df

# Function to insert data into the table
def insert_data(name, age):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO mytable (name, age) VALUES (%s, %s)", (name, age))
    conn.commit()
    conn.close()

# Function to update data in the table
def update_data(id, name, age):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE mytable SET name=%s, age=%s WHERE id=%s", (name, age, id))
    conn.commit()
    conn.close()

# Function to delete data from the table
def delete_data(id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM mytable WHERE id=%s", (id,))
    conn.commit()
    conn.close()

# Streamlit app layout
st.title("CRUD Operations on 'mytable'")

# Tabs for different operations
tab1, tab2, tab3, tab4 = st.tabs(["Create", "Read", "Update", "Delete"])

with tab1:
    st.header("Create New Entry")
    name = st.text_input("Name")
    age = st.number_input("Age", min_value=0, max_value=120, step=1)
    if st.button("Insert"):
        if name:
            insert_data(name, age)
            st.success("Data inserted successfully")
        else:
            st.error("Please enter a name")

with tab2:
    st.header("Read Entries")
    df = fetch_data()
    st.dataframe(df)

with tab3:
    st.header("Update Entry")
    df = fetch_data()
    ids = df['id'].tolist()
    selected_id = st.selectbox("Select ID to Update", ids)
    name = st.text_input("New Name")
    age = st.number_input("New Age", min_value=0, max_value=120, step=1)
    if st.button("Update"):
        if name:
            update_data(selected_id, name, age)
            st.success("Data updated successfully")
        else:
            st.error("Please enter a name")

with tab4:
    st.header("Delete Entry")
    df = fetch_data()
    ids = df['id'].tolist()
    selected_id = st.selectbox("Select ID to Delete", ids, key='delete')
    if st.button("Delete"):
        delete_data(selected_id)
        st.success("Data deleted successfully")

