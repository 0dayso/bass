
CREATE TABLE sys_notice
 (noticeID            INTEGER         NOT NULL  DEFAULT 0,
  notice_start_dt          TIMESTAMP       NOT NULL  DEFAULT current timestamp,
  notice_end_dt          TIMESTAMP       NOT NULL  DEFAULT current timestamp,
  noticetitle         VARCHAR(128)    NOT NULL,
  noticemsg           VARCHAR(4000),
  extend_color		  VARCHAR(30),
  CREATOR           VARCHAR(50)               DEFAULT 'admin',
  STATUS            CHARACTER(2)              default '1'
 )in userspace2;