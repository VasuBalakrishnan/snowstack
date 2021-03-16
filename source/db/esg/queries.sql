select system$pipe_status('esg_series_pipe');

select count(1) from ESG_SERIES;

select * from table(information_schema.copy_history(table_Name => 'esg_series', start_time => dateadd(hours, -1, CURRENT_TIMESTAMP())));

select * from information_schema.load_history;
