import numpy as np
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

client = bigquery.Client.from_service_account_json(SERVICE_ACCOUNT_FILE)

query = f"SELECT * FROM `{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}`"
df = client.query(query).to_dataframe()

df.replace([np.inf, -np.inf], np.nan, inplace=True)
df.fillna("", inplace=True)


scopes = ['https://www.googleapis.com/auth/spreadsheets']
credentials = ServiceAccountCredentials.from_json_keyfile_name(SERVICE_ACCOUNT_FILE, scopes)
gc = gspread.authorize(credentials)

SPREADSHEET_ID = '1tCunA1i86ZlUgWIDN5gpl8f4Rt44lVfsa4pq2PYAgu0'
sh = gc.open_by_key(SPREADSHEET_ID)

worksheet = sh.get_worksheet(0)

worksheet.clear()

worksheet.update([df.columns.values.tolist()] + df.values.tolist())

print("Данные успешно загружены")
