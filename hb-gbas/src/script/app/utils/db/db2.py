# -*- coding: utf-8 -*-
"""
ibm_db ibm_db_sa
"""
from sqlalchemy import create_engine
from sqlalchemy.pool import NullPool
import numpy as np
from .comm import chk_para_type


class Connection(object):
    
    def __init__(self,**kwargs):
        self.init_args = kwargs
        self.conn = None  
    
    def connect(self):
        self.conn = create_engine(
            "db2+ibm_db://{user}:{passwd}@{host}:{port}/{db}".format(
                host = self.init_args['host'], 
                port = self.init_args['port'], 
                user = self.init_args['user'], 
                passwd = self.init_args['passwd'], 
                db = self.init_args['db'], 
                poolclass=NullPool
            ),echo=False)

    def ping(self):
        try:
            self.connect()
            return True
        except Exception as e:
            print e
            return False

    def sql_sampling(self,sql):
        if not self.conn : self.connect()
        curs = self.conn.execute('select * from ({sql}) a fetch first 50 rows only with ur'.format(sql=sql))
        col = [(i[0],i[1].col_types[0]) for i in curs.cursor.description]
        data = np.array(curs.fetchall()).T
        _lst = []
        for i in range(len(col)):
            _d = [k for k in set(data[i])]
            _lst.append({
                'field_name':col[i][0].lower(), #db2数据库字段是大写, pandas 加载是小写 ,这里默认都强制转换成小写
                'type'  : col[i][1],
                'sample': map(str,_d) if len(_d)<=5 else map(str,_d[:5])+['...'],
                'para_type': chk_para_type(_d)
            })
        curs.close()
        return _lst