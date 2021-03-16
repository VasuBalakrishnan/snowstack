!set variable_substitution=true;

create database if not exists esg;

use database esg;

create or replace notification integration azure_evt_grid_notification
    enabled = true
type = queue
notification_provider = azure_storage_queue
azure_storage_queue_primary_uri = 'https://stosnowstack.queue.core.windows.net/stosnowstackqueue'
azure_tenant_id = '&azure_tenant_id';


use schema public;

create or replace stage esg_series_stage
    url = '&azure_storage_location/series/'
    credentials = (azure_sas_token = '&azure_sas_token')
    file_format = csvformat;


create or replace table esg_series
(
    "Series Code" string,
    "Topic" string,
    "Indicator Name" string,
    "Short definition" string,
    "Long definition" string,
    "Unit of measure" string,
    "Periodicity" string,
    "Base Period" string,
    "Other notes" string,
    "Aggregation method" string,
    "Limitations and exceptions" string,
    "Notes from original source" string,
    "General comments" string,
    "Source" string,
    "Statistical concept and methodology" string,
    "Development relevance" string,
    "Related source links" string,
    "Other web links" string,
    "Related indicators" string,
    "License Type" string,
    DUMMY string
);

create or replace pipe esg_series_pipe
auto_ingest = true
integration = azure_evt_grid_notification
as
    copy into esg_series
    from @esg_series_stage
    file_format = (format_name = csvformat)
    on_error = 'skip_file';

