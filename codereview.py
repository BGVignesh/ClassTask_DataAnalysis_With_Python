from openai import OpenAI
import streamlit as st

st.title("📝Code Review")

f = open(r"C:\\Users\\hi\\Desktop\\Innomatics\\Internship 2024 Sample Docs\\API\\keys\\practice_API_key.txt")
key = f.read()
client = OpenAI(api_key = key)

pycode = st.text_area("Please Enter your python code", height=200)

if st.button("Review Code") == True:
    response = client.chat.completions.create(
                model = 'gpt-3.5-turbo',
                messages = [
                    {"role":"system", "content": """You are a helpful AI Assistant.
                                                    Accept code as user input. Identify and mention the bugs in the code.
                                                    Generate the correct code.
                                                    Output must be in: {"Bugs":"review_on_code", "code":'''fixed code'''} """},
                    {"role":"user", "content": pycode}]
    )

    error = (response.choices[0].message.content)
    st.header("Reviewing Code")
    st.write(error)