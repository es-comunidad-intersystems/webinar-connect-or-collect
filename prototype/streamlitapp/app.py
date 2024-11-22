import os
import streamlit as st
import psycopg2
import pandas as pd
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode

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
        password=DB_PASSWORD,
        port=DB_PORT
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

def main():
    st.title("CRUD Operations on 'mytable'")

    # Fetch data
    df = fetch_data()

    # Initialize session state for edit
    if 'edit' not in st.session_state:
        st.session_state.edit = False
        st.session_state.edit_id = None

    # Display data using AgGrid
    st.subheader("Table Content")

    gb = GridOptionsBuilder.from_dataframe(df)
    gb.configure_selection('single', use_checkbox=True)
    gb.configure_grid_options(domLayout='normal')
    grid_options = gb.build()

    grid_response = AgGrid(
        df,
        gridOptions=grid_options,
        update_mode=GridUpdateMode.SELECTION_CHANGED,
        theme='streamlit',
        height=400,
        enable_enterprise_modules=False,
        fit_columns_on_grid_load=True,
        reload_data=True
    )
    
    #selected_rows is a dataframe
    selected_rows=grid_response["selected_rows"]

    if selected_rows is not None and not selected_rows.empty:
        
        selected_row = selected_rows.iloc[0]
        selected_id = str(selected_row['id'])
        
    else:
        selected_row = None
        selected_id = None

    # Buttons for Edit and Delete
    col1, col2 = st.columns([1,1])

    with col1:
        if st.button("Edit"):
            if selected_row is not None:
                st.session_state.edit = True
                st.session_state.edit_id = selected_id
            else:
                st.warning("Please select a row to edit.")

    with col2:
        if st.button("Delete"):
            if selected_row is not None:
                delete_data(selected_id)
                st.success(f"Deleted row with ID {selected_id}")
                st.rerun()
            else:
                st.warning("Please select a row to delete.")

    # Form for adding a new row
    st.subheader("Add New Row")
    with st.form("add_row_form"):
        new_name = st.text_input("Name", key='add_name')
        new_age = st.number_input("Age", min_value=0, max_value=120, step=1, key='add_age')
        form_buttons = st.columns(2)
        with form_buttons[0]:
            save = st.form_submit_button("Save")
        with form_buttons[1]:
            cancel = st.form_submit_button("Cancel")
        if save:
            if new_name:
                insert_data(new_name, new_age)
                st.success("New row added successfully")
                st.rerun()
            else:
                st.error("Please enter a name")
        elif cancel:
            st.info("Addition canceled")

    # Edit form
    if 'edit' in st.session_state and st.session_state.edit:
        # Get the data of the row to edit
        edit_id = st.session_state.edit_id
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT name, age FROM mytable WHERE id=%s", (edit_id,))
        row = cur.fetchone()
        conn.close()
        if row:
            name_value, age_value = row
        else:
            st.error("Selected row not found.")
            st.session_state.edit = False
            st.rerun()
            return

        st.subheader(f"Edit Row ID {edit_id}")
        with st.form("edit_row_form"):
            edit_name = st.text_input("Name", value=name_value, key='edit_name')
            edit_age = st.number_input("Age", min_value=0, max_value=120, step=1, value=age_value, key='edit_age')
            form_buttons = st.columns(2)
            with form_buttons[0]:
                save = st.form_submit_button("Save")
            with form_buttons[1]:
                cancel = st.form_submit_button("Cancel")
            if save:
                update_data(edit_id, edit_name, edit_age)
                st.success(f"Row ID {edit_id} updated")
                st.session_state.edit = False
                st.session_state.edit_id = None
                st.rerun()
            elif cancel:
                st.session_state.edit = False
                st.session_state.edit_id = None
                st.info("Edit canceled")
                st.rerun()

if __name__ == "__main__":
    main()
