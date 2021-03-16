!set variable_substitution=true;

create database if not exists esg;

use database esg;

create or replace file format csvformat
type = 'csv'
field_delimiter = ','
field_optionally_enclosed_by = '"'
null_if = ''
skip_header = 1;

create or replace stage csv_stage
file_format = csvformat;

put file://../../../data/esg/ESGData.csv @csv_stage auto_compress=true;

list @csv_stage;

create or replace table esg_data (
country_name string,
country_code string,
indicator_name string,
indicator_code string,
Y1960 float,
Y1961 float,
Y1962 float,
Y1963 float,
Y1964 float,
Y1965 float,
Y1966 float,
Y1967 float,
Y1968 float,
Y1969 float,
Y1970 float,
Y1971 float,
Y1972 float,
Y1973 float,
Y1974 float,
Y1975 float,
Y1976 float,
Y1977 float,
Y1978 float,
Y1979 float,
Y1980 float,
Y1981 float,
Y1982 float,
Y1983 float,
Y1984 float,
Y1985 float,
Y1986 float,
Y1987 float,
Y1988 float,
Y1989 float,
Y1990 float,
Y1991 float,
Y1992 float,
Y1993 float,
Y1994 float,
Y1995 float,
Y1996 float,
Y1997 float,
Y1998 float,
Y1999 float,
Y2000 float,
Y2001 float,
Y2002 float,
Y2003 float,
Y2004 float,
Y2005 float,
Y2006 float,
Y2007 float,
Y2008 float,
Y2009 float,
Y2010 float,
Y2011 float,
Y2012 float,
Y2013 float,
Y2014 float,
Y2015 float,
Y2016 float,
Y2017 float,
Y2018 float,
Y2019 float,
Y2020 float,
Y2050 float,
DUMMY float
);

copy into esg_data
from @csv_stage/ESGData.csv.gz
file_format = (format_name = csvformat)
on_error = 'skip_file';

create or replace table esg_country
(
"Country Code" string,
"Short Name" string,
"Table Name" string,
"Long Name" string,
"2-alpha code" string,
"Currency Unit" string,
"Special Notes" string,
"Region" string,
"Income Group" string,
"WB-2 code" string,
"National accounts base year" string,
"National accounts reference year" string,
"SNA price valuation" string,
"Lending category" string,
"Other groups" string,
"System of National Accounts" string,
"Alternative conversion factor" string,
"PPP survey year" string,
"Balance of Payments Manual in use" string,
"External debt Reporting status" string,
"System of trade" string,
"Government Accounting concept" string,
"IMF data dissemination standard" string,
"Latest population census" string,
"Latest household survey" string,
"Source of most recent Income and expenditure data" string,
"Vital registration complete" string,
"Latest agricultural census" string,
"Latest industrial data" string,
"Latest trade data" string,
DUMMY string
);

create or replace stage azure_blob_stage
    url = '&azure_storage_location'
    credentials = (azure_sas_token = '&azure_sas_token')
    file_format = csvformat;

copy into esg_country
    from @azure_blob_stage/ESGCountry.csv
    file_format = (format_name = csvformat)
    on_error = 'skip_file';

create or replace storage integration azure_blob_storage_integration
type = external_stage
storage_provider = azure
enabled = true
azure_tenant_id = '&azure_tenant_id'
storage_allowed_locations = ('&azure_storage_location');

create or replace notification integration azure_evt_grid_notification
enabled = true
type = queue
notification_provider = azure_storage_queue
azure_storage_queue_primary_uri = 'https://stosnowstack.queue.core.windows.net/stosnowstackqueue'
azure_tenant_id = '&azure_tenant_id';
