set schema=gbas;
--指标定义表
create table if not exists zb_def
(
zb_code     varchar(32),
zb_name    varchar(512),
zb_def        varchar(2048),      /*sql配置*/
status         varchar(4),             /*上线状态,0开发,1上线,可能与流程相关,数值待定*/
cycle          varchar(8),             /*周期daily,monthly*/
online_date  date,                   /*上线时间*/
offline_date  date,                   /*下线时间,默认2999-12-31*/
developer    varchar(128),     /*开发人*/
)


--指标规则定义表
create table if not exists rule_def
(
rule_code     varchar(32),
rule_name    varchar(512),
rule_def        varchar(2048),      /*配置*/
comp_oper  varchar(32),          /*比较运算符,如==,>=等*/
val              decimal(20,2),         /*阈值*/
status         varchar(4),             /*上线状态,0开发,1上线,可能与流程相关,数值待定*/
cycle          varchar(8),             /*周期daily,monthly*/
online_date  date,                   /*上线时间*/
offline_date  date,                   /*下线时间,默认2999-12-31*/
developer    varchar(128),     /*开发人*/
)


--调度表
create table if not exists run_dispatch
(
id                 bigint,                  /*主键*/
type            varchar(32),         /*zb,rule,export*/
gbas_code   varchar(32),         /*zb_code,rule_code,ex_code*/
cycle          varchar(8),             /*周期daily,monthly*/
etl_cycle_id  varchar(8),         /*例如:20170718*/
etl_status  varchar(4),            /*执行状态*/
proc_depend  varchar(128),  /*指标所依赖的程序*/
zb_depend  varchar(128),  /*规则所依赖的指标*/
rule_depend  varchar(128),  /*接口所依赖的指标规则*/
priority          int,                     /*优先级*/
pid                 varchar(32),
hostname     varchar(64),
expect_end_time  date,   /*例如8.5表示8点半预期完成时间*/
dispatch_time       timestamp,   /*发布时间*/
exec_start_time              timestamp,   /*开始执行时间*/
exec_end_time               timestamp,   /*执行完成时间*/
err_time                           timestamp,   /*报错时间*/
err_msg         varchar(512),  /*报错信息*/
)