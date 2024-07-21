# Chicago Taxi Tips Stats

Этот проект предназначен для анализа данных о чаевых, полученных такси в Чикаго, используя открытые данные из BigQuery. В частности, проект фокусируется на:

1. Определении трех такси, которые получили наибольшее количество чаевых в апреле 2018 года.
2. Расчете изменений в чаевых для этих такси по месяцам в процентах.
3. Загрузке результатов в Google Sheets для удобного просмотра и анализа.

## Содержание

- [Описание проекта](#описание-проекта)
- [Инструменты](#инструменты)
- [Установка](#установка)
- [Запуск проекта](#запуск-проекта)
- [Примеры использования](#примеры-использования)
- [Структура проекта](#структура-проекта)

## Описание проекта

Проект состоит из следующих этапов:

1. **Анализ данных**: Используется набор данных `bigquery-public-data.chicago_taxi_trips` для определения трех такси, которые получили наибольшее количество чаевых в апреле 2018 года.
2. **Расчет изменений**: Для выбранных такси рассчитывается месячное изменение суммы чаевых по сравнению с предыдущими месяцами.
3. **Отчеты и визуализация**: Итоговая таблица с данными о чаевых и их изменениях загружается в Google Sheets для дальнейшего анализа.

## Инструменты

- **dbt**: Инструмент для создания и управления моделями данных.
- **BigQuery**: Система для хранения и обработки больших данных от Google.
- **Google Sheets API**: Для загрузки данных в Google Sheets.

## Установка

1. **Клонирование репозитория**:

    ```bash
    git clone https://github.com/ezulex/mtrendoTaxi.git
    cd mtrendoTaxi/chicago_taxi
    ```

2. **Установка зависимостей**:

    Создайте виртуальное окружение (рекомендуется) и установите необходимые библиотеки:

    ```bash
    python -m venv venv
    source venv/bin/activate  # Для Linux/Mac
    venv\Scripts\activate     # Для Windows
    pip install -r requirements.txt
    ```

3. **Настройка dbt**:

    - Скопируйте файл `profiles.yml` в директорию проекта (создайте её, если она не существует).
    - Поместите файл `service_account.json` в корневую директорию проекта или настройте путь к нему в файле `profiles.yml`.
    - Настройте источник данных, для этого создайте файл  `source.yml` в директории `models/sources`.

    Пример `profiles.yml`:

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
   
   Пример `source.yml`:

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
   
4**Настройка переменных**:
Создайте в корне проекта файл .env и добавьте в него данные для доступа к таблице Google и BigQuery.

```yaml
SERVICE_ACCOUNT_FILE = 'Ваш путь до service-account.json'
PROJECT_ID = 'Ваш проект в Google Console'
DATASET_ID = 'Название вашего Датасета'
TABLE_ID = 'Название итоговой таблице, откуда будут импортироваться данные в Google таблицу'
SPREADSHEET_ID = 'ID таблицы Google, куда записываете данные'
```


## Запуск проекта

1. **Запуск dbt**:

    После настройки и добавления моделей выполните команду:

    ```bash
    dbt build
    ```

2. **Сохранение результатов в Google Sheets**:

    - Убедитесь, что вы настроили доступ к Google Sheets API.
    - Используйте скрипт Python из папки проекта  `scripts/` для загрузки данных в Google Sheets.

    Пример команды для выполнения скрипта:

    ```bash
    python scripts/chicago_taxi_stats_gsheet_export.py
    ```

## Примеры использования

После выполнения dbt моделей и скрипта для загрузки в Google Sheets, вы можете увидеть результаты анализа в вашем Google Sheets документе. Документ будет содержать таблицу с колонками `taxi_id`, `year_month`, `tips_sum`, и `tips_change`.

## Структура проекта

- **`models/stage`**: Содержит dbt модели для обработки и анализа данных.
  - `top_3_taxis.sql`: Модель для вычисления топ 3 такси с наибольшими чаевыми в апреле 2018 года.
  - `monthly_tips.sql`: Модель для получения чаевых всех такси за каждый месяц с апреля 2018 года.
  - `tips_with_previous.sql`: Модель для получения разницы чаевых от месяца к месяцу.
  - `tips_change.sql`: Модель для создания итоговой таблицы.
  - `schema.yml`: Тесты моделей.
- **`models/sources`**: Содержит источники данных.
  - `sources.yml`: Список источников данных.
- **`scripts/`**: Python скрипты для работы с данными.
  - `chicago_taxi_stats_gsheet_export.py`: Скрипт для загрузки данных в Google Sheets.
- **`profiles.yml`**: Конфигурационный файл dbt для подключения к BigQuery.
- **`acc/`**: Содержит настройки доступов.
  - `service_account.json`: Файл с учетными данными для доступа к Google Cloud API.
- **`requirements.txt`**: Список необходимых библиотек для работы.
- **`dbt_project.yml`**: Настройки проекта dbt


