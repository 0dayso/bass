drop TABLE PT.SYS_MENU_ITEMS;
CREATE TABLE PT.SYS_MENU_ITEMS
 (MENUITEMID     VARCHAR(64)    NOT NULL  DEFAULT '0',
  PARENTID     VARCHAR(64)    NOT NULL  DEFAULT '0',
  MENUITEMTITLE  VARCHAR(128)    NOT NULL,
  SORTNUM        INTEGER         NOT NULL DEFAULT 0,
  ICONURL          VARCHAR(64) NOT NULL DEFAULT '',
  URL           VARCHAR(255),
  MENUTYPE       INTEGER         NOT NULL DEFAULT 0,
  state  		 INTEGER      DEFAULT 1/*非零为开启，0为关闭*/
 )
  DATA CAPTURE NONE
 IN "USERSPACE2";

ALTER TABLE "PT"."SYS_MENU_ITEMS"
  LOCKSIZE ROW
  APPEND OFF
  NOT VOLATILE
  LOG INDEX BUILD NULL;
 
  /*
  insert into pt.SYS_MENU_ITEMS
select   MENUITEMID   ,
  PARENTID     ,
  MENUITEMTITLE,
  SORTNUM      ,
  pic1 ICONURL      ,
  URL          ,
  MENUTYPE,1 state      from pt.SYS_MENU_ITEM;*/
  
CREATE TABLE PT.SYS_DIM_VALUE
 (DIM_ID     VARCHAR(20)    NOT NULL  DEFAULT '0',
  DIM_VALUE     VARCHAR(64)    NOT NULL  DEFAULT '0',
  SORTNUM        INTEGER         NOT NULL DEFAULT 0,
  DIMTYPENAME	VARCHAR(20)	   NOT NULL DEFAULT ''
 )
  DATA CAPTURE NONE
 IN "USERSPACE2";

ALTER TABLE PT.SYS_DIM_VALUE
  LOCKSIZE ROW
  APPEND OFF
  NOT VOLATILE
  LOG INDEX BUILD NULL;
  
  COMMENT ON PT.SYS_DIM_VALUE
 (DIM_ID IS '维度id',
 DIM_VALUE is '维度值',
 SORTNUM is '同维度排序',
 DIMTYPENAME is '维度类型名称'
 );