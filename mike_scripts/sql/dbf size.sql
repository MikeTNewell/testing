SELECT file_name, SUM(bytes)/1024/1024 DF_SIZE
FROM dba_data_files
GROUP BY file_name;

select sum(bytes)/1024/1024 from v$log;

select * from v$parameter where name = 'log_archive_dest';