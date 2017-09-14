SELECT C.REV_DB_ID,
DB.SITE_CD "SITE_CD",
SUBSTR(DB.DB_NM,1,20) "DB_NM",
C.MAF_UPDATES "MAF UPDATES",
extract(day from C.MIN_INTERVAL)||' days, '
||extract(hour from C.MIN_INTERVAL)||' hr, '
||extract(minute from C.MIN_INTERVAL)||' min, '
||extract(second from C.MIN_INTERVAL)||' sec ' "MIN INTERVAL",
extract(day from C.MAX_INTERVAL)||' days, '
||extract(hour from C.MAX_INTERVAL)||' hr, '
||extract(minute from C.MAX_INTERVAL)||' min, '
||extract(second from C.MAX_INTERVAL)||' sec ' "MAX INTERVAL",
extract(day from C.AVG_INTERVAL)||' days, '
||extract(hour from C.AVG_INTERVAL)||' hr, '
||extract(minute from C.AVG_INTERVAL)||' min, '
||round(extract(second from C.AVG_INTERVAL))||' sec ' "AVG INTERVAL",
extract(day from A.MAF_INTERVAL)||' days, '
||extract(hour from A.MAF_INTERVAL)||' hr, '
||extract(minute from A.MAF_INTERVAL)||' min, '
||extract(second from A.MAF_INTERVAL)||' sec ' "MEDIAN INTERVAL"
FROM
  DBO.DB DB,
  (SELECT ROWNUM "SEQ_NUM",
  REV_DB_ID, MAF_TT03_DT, MAF_INTERVAL
  FROM 
   (SELECT REV_DB_ID, MAF_TT03_DT, MAF_INTERVAL
    FROM OOMA_METRICS.MAF_TT03_AUDIT1
    ORDER BY REV_DB_ID, MAF_INTERVAL)) A,  (SELECT B.REV_DB_ID, FLOOR(MEDIAN(B.SEQ_NUM)) "MEDIAN",
  COUNT(1) "MAF_UPDATES",
  MIN(B.MAF_INTERVAL) "MIN_INTERVAL",
  MAX(B.MAF_INTERVAL) "MAX_INTERVAL",
  ooma_metrics.avg_interval(MAF_INTERVAL) "AVG_INTERVAL"
  FROM 
   (SELECT SEQ_NUM, REV_DB_ID, MAF_TT03_DT, MAF_INTERVAL 
    FROM  
     (SELECT ROWNUM "SEQ_NUM", 
      REV_DB_ID, MAF_TT03_DT, MAF_INTERVAL  
      FROM 
       (SELECT REV_DB_ID, MAF_TT03_DT, MAF_INTERVAL
        FROM OOMA_METRICS.MAF_TT03_AUDIT1
        ORDER BY REV_DB_ID, MAF_INTERVAL))
      WHERE MAF_TT03_DT > TO_DATE
      ('06-MAY-10 23.59.59','DD-MON-YY HH24.MI.SS')
      AND MAF_TT03_DT < TO_DATE
      ('13-MAY-10 23.59.59','DD-MON-YY HH24.MI.SS'))B
    GROUP BY B.REV_DB_ID) C
  WHERE A.REV_DB_ID = C.REV_DB_ID
  AND A.SEQ_NUM = C.MEDIAN
  AND A.REV_DB_ID = DB.DB_ID
;