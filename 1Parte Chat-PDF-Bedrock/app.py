import boto3
import streamlit as st
import os
import uuid
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.embeddings import BedrockEmbeddings # <--Bedrock
from langchain_community.vectorstores import FAISS #<-- faiss
from langchain_community.llms import Bedrock
from langchain.prompts import PromptTemplate
from langchain.chains import RetrievalQA

#Bedrock client
bedrock_client = boto3.client(service_name = "bedrock-runtime", region_name="us-east-1")
bedrockembedding = BedrockEmbeddings(model_id="amazon.titan-embed-text-v1", client=bedrock_client)


def get_llm():
    llm = Bedrock(
        model_id="meta.llama3-70b-instruct-v1:0", 
        client=bedrock_client
    )
    return llm

def get_response(llm,vectorstore, question ):
    ## create prompt / template
    prompt_template = """
    Humano: Por favor, utiliza el contexto proporcionado para dar una respuesta concisa a la pregunta. 
    Si no conoces la respuesta, simplemente di que no lo sabes; no intentes inventar una respuesta.
    <context>
    {context}
    </context>

    Question: {question}

    Assistant:"""

    PROMPT = PromptTemplate(
        template=prompt_template, input_variables=["context", "question"]
    )

    qa = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(
        search_type="similarity", search_kwargs={"k": 5}
    ),
    return_source_documents=True,
    chain_type_kwargs={"prompt": PROMPT}
)
    answer=qa({"query":question})
    return answer['result']

## Split the pages / text into chuncks
def split_text(pages, chunk_size, chunk_overlap):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    docs = text_splitter.split_documents(pages)
    return docs

# Create the vector store
def create_vector_store(request_id, splitted_docs):
    vectorstore_faise = FAISS.from_documents(splitted_docs, bedrockembedding)
    file_name = request_id
    folder_path = "/tmp/"
    vectorstore_faise.save_local(index_name=file_name, folder_path=folder_path)
    files_in_tmp = os.listdir(folder_path)
    #st.write(f"Files in {folder_path}: {files_in_tmp}")
    return True

#main method
def main():
    st.markdown("<h1 style='text-align: center;'>Realiza consultas a tu documento PDF usando IA</h1>", unsafe_allow_html=True)
    uploaded_file = st.file_uploader("Elige un archivo", type="pdf")

    if uploaded_file is not None:
        if "request_id" not in st.session_state:    
            st.session_state.request_id = str(uuid.uuid4())[:8]

        file_name = f"{uploaded_file.name}_{st.session_state.request_id}.pdf"
        with open (file_name, mode="wb") as w:
            w.write(uploaded_file.getvalue())        
        loader = PyPDFLoader(file_name)
        pages = loader.load_and_split()


        splitted_docs = split_text(pages, 1000, 500)

        #st.write(f"Splitted Docs lengths: {len(splitted_docs)}")

        with st.spinner("Creando almacen de Vectores"):
            if "result" not in st.session_state:
                st.session_state.result = create_vector_store(st.session_state.request_id, splitted_docs)        

        faiss_index = FAISS.load_local(
        index_name=st.session_state.request_id,
        folder_path = "/tmp/",
        embeddings=bedrockembedding,
        allow_dangerous_deserialization=True
    )
        st.write("El almacen de vectores fue creado exitosamente")
        question = st.text_input("Por favor realiza tu pregunta")
        if st.button("Consultar"):
            with st.spinner("Respondiendo..."):

                llm = get_llm()

                # get_response
                st.write(get_response(llm, faiss_index, question))
                st.success("proceso EXITOSO!!")


if __name__ == "__main__":
    main()


# docker build -t Chat-pdf . 

# docker run -it -p 8083:8083 Chat-pdf

# docker run -it -v ~/.aws:/root/.aws -p 8083:8083 Chat-pdf
