rename table st.fpf_tab1 to fpf_bir_subject_sid_map;
  
rename table st.fpf_tab2 to fpf_bir_subject_sid_term_map;

alter table st.fpf_visitlist alter column CREATE_DT set with default CURRENT TIMESTAMP;

create table fpf_kpi_visit(
kpi_code character(20) not null,
kpi_name varchar(200),
kpi_category varchar(100),
user_name varchar(100),
visit_time TIMESTAMP
);

create INDEX IDX_KPI_COMP_CD005_M_VERTICAL_1 ON KPI_COMP_CD005_M_VERTICAL(KPI_CODE);
create INDEX IDX_KPI_COMP_CD005_M_VERTICAL_2 ON KPI_COMP_CD005_M_VERTICAL(OP_TIME);
create INDEX IDX_KPI_COMP_CD005_M_VERTICAL_3 ON KPI_COMP_CD005_M_VERTICAL(DIM_CODE);
create INDEX IDX_KPI_COMP_CD005_M_VERTICAL_4 ON KPI_COMP_CD005_M_VERTICAL(DIM_VAL);
create INDEX IDX_KPI_COMP_CD005_M_VERTICAL_5 ON KPI_COMP_CD005_M_VERTICAL(KPI_CODE,OP_TIME,DIM_CODE,DIM_VAL);
create INDEX IDX_KPI_COMP_CD005_M_VERTICAL_6 ON KPI_COMP_CD005_M_VERTICAL(KPI_CODE,DIM_CODE,DIM_VAL);
runstats on table st.KPI_COMP_CD005_M_VERTICAL;

ALTER TABLE ST.KPI_LOGIC_DEF ADD DIVISION  VARCHAR(16) NOT NULL  DEFAULT 1;

create INDEX IDX_KPI_DEF_1 ON ST.KPI_DEF(LOGIC_KPICODE);
create INDEX IDX_KPI_DEF_2 ON ST.KPI_DEF(KPI_CODE);
create INDEX IDX_KPI_LOGIC_DEF_1 ON ST.KPI_DEF(LOGIC_KPICODE);

create VIEW st.v_kpi_def as select KPI_CODE,f.KPI_UNIT,f.division from ST.KPI_DEF d left join st.KPI_LOGIC_DEF f on d.LOGIC_KPICODE=f.LOGIC_KPICODE;

---多维度数据导入临时表---
CREATE TABLE "ST"."USER_VALUE_FINANCE_IMP_TMP"
 ("TASK_ID"    VARCHAR(20),
  "PROD_CODE"  VARCHAR(40),
  "PROD_NAME"  VARCHAR(200),
  "TOTAL_FEE"  DECIMAL(20, 2)
 );
 
alter table st.fpf_irs_twitter add column end_time varchar(40);
alter table st.fpf_irs_twitter add column bomc_id varchar(100);
create sequence st.fpf_irs_twitter_id as int start WITH 1 INCREMENT BY 1 MINVALUE 1 NO MAXVALUE NO CYCLE NO CACHE ORDER;