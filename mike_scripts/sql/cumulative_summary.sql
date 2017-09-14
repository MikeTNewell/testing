SELECT
RTRIM(C.MIN_DATE) "BEGIN DATE",
RTRIM(C.MAX_DATE) "END DATE",
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
  (SELECT ROWNUM "SEQ_NUM", MAF_INTERVAL
  FROM 
   (SELECT MAF_INTERVAL
    FROM OOMA_METRICS.MAF_TT03_AUDIT1
    ORDER BY MAF_INTERVAL)) A,
 (SELECT FLOOR(MEDIAN(B.SEQ_NUM)) "MEDIAN",
  MIN(B.MAF_TT03_DT) "MIN_DATE",
  MAX(B.MAF_TT03_DT) "MAX_DATE",
  MIN(B.MAF_INTERVAL) "MIN_INTERVAL",
  MAX(B.MAF_INTERVAL) "MAX_INTERVAL",
  ooma_metrics.avg_interval(MAF_INTERVAL) "AVG_INTERVAL"
  FROM 
   (SELECT SEQ_NUM, MAF_TT03_DT, MAF_INTERVAL 
    FROM  
     (SELECT ROWNUM "SEQ_NUM", MAF_TT03_DT, MAF_INTERVAL  
      FROM 
       (SELECT MAF_TT03_DT, MAF_INTERVAL
        FROM OOMA_METRICS.MAF_TT03_AUDIT1
        ORDER BY MAF_INTERVAL))
      WHERE MAF_TT03_DT < TO_DATE
      ('20-MAY-10 23.59.59','DD-MON-YY HH24.MI.SS'))B) C
  WHERE A.SEQ_NUM = C.MEDIAN