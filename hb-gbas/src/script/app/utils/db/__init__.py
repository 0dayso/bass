# -*- coding: utf-8 -*-

class DB(object):
    
    def __init__(self,dbconfig):
        self.dbconfig = dbconfig
        
    def conn(self):
        if self.dbconfig.db_type == 'mysql':
            from .mysql import Connection as mysql_conn
            db = mysql_conn(
                host=self.dbconfig.db_host, 
                port=int(self.dbconfig.db_port), 
                user=self.dbconfig.db_user, 
                passwd=self.dbconfig.db_password, 
                db=self.dbconfig.db_name)

        elif self.dbconfig.db_type == 'db2':
            from .db2 import Connection as db2_conn
            db = db2_conn(
                host=self.dbconfig.db_host, 
                port=int(self.dbconfig.db_port), 
                user=self.dbconfig.db_user, 
                passwd=self.dbconfig.db_password, 
                db=self.dbconfig.db_name)

        elif self.dbconfig.db_type == 'hive':
            from .hive import Connection as hive_conn
            db = hive_conn(
                host=self.dbconfig.db_host, 
                port=int(self.dbconfig.db_port), 
                user=self.dbconfig.db_user, 
                passwd=self.dbconfig.db_password, 
                db=self.dbconfig.db_name)
        
        else:
            raise Exception("db_type不支持")

        return db