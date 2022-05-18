#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import fitz
import os


# In[ ]:





# In[ ]:


def PDF2text(doc):
    doc = fitz.open(doc)
    pgno = -1
    document = ""
    while True:
        pgno += 1
        try: 
            page1 = doc[pgno]
            document = document + " ***** " + page1.get_text("text")
        except:
            break
    return(document)


# In[ ]:





# In[1]:


def cleaning_pipeline(raw_text):
    doc_cleaned = raw_text.replace("\n"," ").replace("\t", " ").lower()
    p = '!"#$%&\'()*+,-/:;<=>?@[\\]^_`{|}~”“'
    trans = str.maketrans("","",p)
    doc_cleaned = doc_cleaned.translate(trans)
    doc_cleaned = doc_cleaned.replace("•"," ")
    doc_cleaned = doc_cleaned.replace("\uf0d8", " ")
    doc_cleaned = doc_cleaned.replace("\uf075'", " ")
    doc_cleaned = doc_cleaned.replace("  ", " ")
    doc_cleaned = doc_cleaned.replace("   "," ").strip()
    return(doc_cleaned)


# In[ ]:





# In[ ]:


import textstat

def readibility(bank_name, report):
    read_scores = {"Year": [], "Flesch-Kincaid": [], "Gunning": [], "SMOG": [], "ARI": [], "CLI": [], "Linsear": [], "DC": [], "Standard":[]}

    for file in os.listdir():
        if ".pdf" in file:
            document = PDF2text(file)
            cleaned_file = cleaning_pipeline(document)

            if len(cleaned_file) != 0:
                #Readibility scores
                read_scores["Flesch-Kincaid"].append(textstat.flesch_kincaid_grade(cleaned_file))
                read_scores["Gunning"].append(textstat.gunning_fog(cleaned_file))
                read_scores["SMOG"].append(textstat.smog_index(cleaned_file))
                read_scores["ARI"].append(textstat.automated_readability_index(cleaned_file))
                read_scores["CLI"].append(textstat.coleman_liau_index(cleaned_file))
                read_scores["Linsear"].append(textstat.linsear_write_formula(cleaned_file))
                read_scores["DC"].append(textstat.dale_chall_readability_score(cleaned_file))
                read_scores["Standard"].append(textstat.text_standard(cleaned_file)) 
                #Year
                read_scores["Year"].append(int(file[file.find("_")+1:file.find("-")]))
            else:
                read_scores["Flesch-Kincaid"].append(np.NaN)
                read_scores["Gunning"].append(np.NaN)
                read_scores["SMOG"].append(np.NaN)
                read_scores["ARI"].append(np.NaN)
                read_scores["CLI"].append(np.NaN)
                read_scores["Linsear"].append(np.NaN)
                read_scores["DC"].append(np.NaN)
                read_scores["Standard"].append(np.NaN)  
                read_scores["Year"].append(int(file[file.find("_")+1:file.find("-")]))
            print(file)
            
    df = pd.DataFrame(read_scores)
    df["Bank"] = bank_name
    df["Report"] = report
    return(df)

