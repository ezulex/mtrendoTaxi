import string

import numpy as np
import pandas as pd
from google.cloud import bigquery
from oauth2client.service_account import ServiceAccountCredentials
import gspread
import os
from dotenv import load_dotenv

load_dotenv()
SERVICE_ACCOUNT_FILE = os.environ.get("SERVICE_ACCOUNT_FILE")
PROJECT_ID = os.environ.get("PROJECT_ID")
DATASET_ID = os.environ.get("DATASET_ID")
TABLE_ID = os.environ.get("TABLE_ID")
SPREADSHEET_ID = os.environ.get("SPREADSHEET_ID")

client = bigquery.Client.from_service_account_json(SERVICE_ACCOUNT_FILE)

query = f"SELECT * FROM `{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}`"
df = client.query(query).to_dataframe()

df.replace([np.inf, -np.inf], np.nan, inplace=True)
df.fillna("", inplace=True)


scopes = ['https://www.googleapis.com/auth/spreadsheets']
credentials = ServiceAccountCredentials.from_json_keyfile_name(SERVICE_ACCOUNT_FILE, scopes)
gc = gspread.authorize(credentials)


sh = gc.open_by_key(SPREADSHEET_ID)

worksheet = sh.get_worksheet(0)

worksheet.clear()

worksheet.update([df.columns.values.tolist()] + df.values.tolist())

print("Data successfully exported")
