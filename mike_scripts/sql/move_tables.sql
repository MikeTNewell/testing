spool move_tables.log
alter table DBO.MAF_CORRECT_DCO move tablespace OOMA_DAT;                       
alter table DBO.SQLLDR_COL_DEF_BK move tablespace OOMA_DAT;                     
alter table DBO.SQLLDR_DATE_METADATA_BK move tablespace OOMA_DAT;               
alter table DBO.REF_PASS_PRI_CD_BK move tablespace OOMA_DAT;                    
alter table DBO.WORKTABLETS move tablespace OOMA_DAT;                           
alter table DBO.MAF_CORRECT_HST_REP move tablespace OOMA_DAT;                   
alter table DBO.MAF_CORRECT_HST_PRIM move tablespace OOMA_DAT;                  
alter table DBO.REFRESH_INDEXES move tablespace OOMA_DAT;                       
alter table DBO.AFTER_REFRESH_INDEXES move tablespace OOMA_DAT;                 
alter table DBO.MAF_COMPOSITE_KEYS move tablespace OOMA_DAT;                    
alter table DBO.NFDOC_COMPOSITE_KEYS move tablespace OOMA_DAT;                  
alter table DBO.SQLLDR_DATE_METADATA move tablespace OOMA_DAT;                  
alter table DBO.SQLLDR_CTRL_METADATA move tablespace OOMA_DAT;                  
alter table DBO.REQUISITION_DCO move tablespace OOMA_DAT;                       
alter table DBO.PERSONNEL_DCO move tablespace OOMA_DAT;                         
alter table DBO.CDI_QAR_INSP_DCO move tablespace OOMA_DAT;                      
alter table DBO.ACTL_TSK_DUE_DCO move tablespace OOMA_DAT;                      
alter table DBO.ACTL_TSK_DCO move tablespace OOMA_DAT;                          
alter table DBO.MAF_DCO move tablespace OOMA_DAT;                               
alter table DBO.MAF_HOURS_DCO move tablespace OOMA_DAT;                         
alter table DBO.MAF_REMOVE_REF_DCO move tablespace OOMA_DAT;                    
alter table DBO.MAF_REMOVE_DCO move tablespace OOMA_DAT;                        
alter table DBO.MAF_SIGN_OFFS_DCO move tablespace OOMA_DAT;                     
alter table DBO.MAF_JSHISTORY_DCO move tablespace OOMA_DAT;                     
alter table DBO.MAF_DISCREP_DCO move tablespace OOMA_DAT;                       
alter table DBO.REF_PASS_PRI_CD move tablespace OOMA_DAT;                       
spool off

