# Chicago Taxi Tips Stats

This project is designed to analyze tips received by taxis in Chicago using open data from BigQuery. Specifically, the project focuses on:

1. Identifying the three taxis that received the most tips in April 2018.
2. Calculating the percentage change in tips for these taxis by month.
3. Uploading the results to Google Sheets for easy viewing and analysis.

## Table of Contents

- [Project Description](#project-description)
- [Tools](#tools)
- [Installation](#installation)
- [Running the Project](#running-the-project)
- [Usage Examples](#usage-examples)
- [Project Structure](#project-structure)

## Project Description

The project consists of the following stages:

1. **Data Analysis**: Using the dataset `bigquery-public-data.chicago_taxi_trips` to identify the three taxis that received the most tips in April 2018.
2. **Change Calculation**: Calculating the monthly percentage change in tips for the selected taxis compared to previous months.
3. **Reports and Visualization**: Uploading the final table with tip data and their changes to Google Sheets for further analysis.

## Tools

- **dbt**: A tool for building and managing data models.
- **BigQuery**: Google's data warehouse for large-scale data processing.
- **Google Sheets API**: For uploading data to Google Sheets.

## Installation

1. **Clone the repository**:

    ```bash
    git clone https://github.com/ezulex/mtrendoTaxi.git
    cd mtrendoTaxi/chicago_taxi
    ```

2. **Install dependencies**:

    Create a virtual environment (recommended) and install the required libraries:

    ```bash
    python -m venv venv
    source venv/bin/activate  # For Linux/Mac
    venv\Scripts\activate     # For Windows
    pip install -r requirements.txt
    ```

3. **Configure dbt**:

    - Copy the `profiles.yml` file to the project directory (create it if it doesn't exist).
    - Place the `service_account.json` file in the root directory of the project or configure its path in the `profiles.yml` file.
    - Configure the data source by creating a `source.yml` file in the `models/sources` directory.

    Example `profiles.yml`:

    ```yaml
    my_bigquery_profile:
      target: dev
      outputs:
        dev:
          type: bigquery
          method: service_account
          project: <your-project-id>
          dataset: <your-dataset>
          keyfile: path/to/service_account.json
          threads: 1
    ```

    Example `source.yml`:

    ```yaml
    version: 2
    sources:
    - name: chicago_taxi_trips
      database: bigquery-public-data
      schema: chicago_taxi_trips
      tables:
        - name: taxi_trips
          description: "This table contains detailed information about taxi trips in Chicago."
          columns:
            - name: unique_key
              description: "Unique identifier for the taxi trip."
            - name: taxi_id
              description: "Identifier for the taxi."
            - name: trip_start_timestamp
              description: "Timestamp for when the trip started."
            - name: trip_end_timestamp
              description: "Timestamp for when the trip ended."
            - name: trip_seconds
              description: "Duration of the trip in seconds."
            - name: trip_miles
              description: "Distance of the trip in miles."
            - name: pickup_census_tract
              description: "Census tract where the trip started."
            - name: dropoff_census_tract
              description: "Census tract where the trip ended."
            - name: pickup_community_area
              description: "Community area where the trip started."
            - name: dropoff_community_area
              description: "Community area where the trip ended."
            - name: fare
              description: "Fare for the trip."
            - name: tips
              description: "Tips given for the trip."
            - name: tolls
              description: "Tolls for the trip."
            - name: extras
              description: "Extra charges for the trip."
            - name: trip_total
              description: "Total amount charged for the trip."
            - name: payment_type
              description: "Payment type used for the trip."
            - name: company
              description: "Taxi company providing the service."
            - name: pickup_latitude
              description: "Latitude where the trip started."
            - name: pickup_longitude
              description: "Longitude where the trip started."
            - name: pickup_location
              description: "Location where the trip started."
            - name: dropoff_latitude
              description: "Latitude where the trip ended."
            - name: dropoff_longitude
              description: "Longitude where the trip ended."
            - name: dropoff_location
              description: "Location where the trip ended."
    ```

4. **Configure environment variables**:

    Create a `.env` file in the root directory of the project and add the following information for accessing the Google Sheet and BigQuery table.

    ```yaml
    SERVICE_ACCOUNT_FILE='path/to/service-account.json'
    PROJECT_ID='your-google-project-id'
    DATASET_ID='your-dataset-id'
    TABLE_ID='your-final-table-id'
    SPREADSHEET_ID='your-google-sheet-id'
    ```

## Running the Project

1. **Run dbt**:

    To run the project, execute the command:

    ```bash
    dbt build -s +tips_change
    ```

2. **Save results to Google Sheets**:

    - Ensure you have configured access to the Google Sheets API.
    - Use the Python script in the `scripts/` folder to upload data to Google Sheets.

    Example command to run the script:

    ```bash
    python scripts/chicago_taxi_stats_gsheet_export.py
    ```

## Usage Examples

After running the dbt models and the script to upload to Google Sheets, you can view the analysis results in your Google Sheets document. The document will contain a table with columns `taxi_id`, `year_month`, `tips_sum`, and `tips_change`.

## Project Structure

- **`models/stage`**: Contains dbt models for data processing and analysis.
  - `top_3_taxis.sql`: Model for computing the top 3 taxis with the most tips in April 2018.
  - `monthly_tips.sql`: Model for getting tips for all taxis by month from April 2018.
  - `tips_with_previous.sql`: Model for getting the month-to-month difference in tips.
  - `tips_change.sql`: Model for creating the final table.
  - `schema.yml`: Model tests.
- **`models/sources`**: Contains data sources.
  - `sources.yml`: List of data sources.
- **`scripts/`**: Python scripts for working with data.
  - `chicago_taxi_stats_gsheet_export.py`: Script for uploading data to Google Sheets.
- **`profiles.yml`**: dbt configuration file for connecting to BigQuery.
- **`acc/`**: Contains access settings.
  - `service_account.json`: Credential file for accessing Google Cloud API.
- **`requirements.txt`**: List of required libraries.
- **`dbt_project.yml`**: dbt project settings.
