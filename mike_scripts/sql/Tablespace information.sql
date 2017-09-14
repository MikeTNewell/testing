-- Free space for tablespaces 
SELECT a.tablespace_name, a.file_name, a.bytes allocated_bytes, 
 b.free_bytes
 FROM dba_data_files a, 
 (SELECT file_id, SUM(bytes) free_bytes
 FROM dba_free_space b GROUP BY file_id) b
 WHERE a.file_id=b.file_id
 ORDER BY a.tablespace_name;

-- Data file size in MB  
SELECT file_name, SUM(bytes)/1024/1024 DF_SIZE
FROM dba_data_files
GROUP BY file_name;

-- Data file information 
SELECT file_name, tablespace_name, 
       bytes/1024/1024 MB, blocks
FROM dba_data_files
UNION ALL
SELECT file_name, tablespace_name, 
       bytes/1024/1024 MB, blocks
FROM dba_temp_files
ORDER BY tablespace_name, file_name;

-- Add dbf to a tablespace 
ALTER TABLESPACE lmtbsb
   ADD DATAFILE '/u02/oracle/data/lmtbsb02.dbf' SIZE 1M;
   
-- Rename a tablespace 
/*
ALTER TABLESPACE users RENAME TO usersts;
*/

-- Drop a tablespace 
/*
DROP TABLESPACE users INCLUDING CONTENTS AND DATAFILES;
*/

-- Resize a datafile 
ALTER DATABASE DATAFILE 'c:\oracle\oradata\orabase\tools02.tom'
RESIZE 50M;

-- Turn off autoextend 
ALTER DATABASE DATAFILE 'u06/oradata/tools01.dbf' AUTOEXTEND OFF;

-- Turn on autoextend 
ALTER DATABASE DATAFILE 'u06/oradata/tools01.dbf' AUTOEXTEND ON MAXSIZE UNLIMITED;

-- Segment Information 
SELECT segment_name, file_id
FROM dba_extents
--WHERE tablespace_name = 'BOWIE_DATA'
ORDER BY segment_name;

create tablespace ts_sth 
  datafile 'c:\xx\sth_01.dbf' size 4M autoextend off,
           'c:\xx\sth_02.dbf' size 4M autoextend off,
           'c:\xx\sth_03.dbf' size 4M autoextend off
  logging
  extent management local;

