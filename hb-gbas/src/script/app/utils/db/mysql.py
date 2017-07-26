# -*- coding: utf-8 -*-
import pymysql
from pymysql import FIELD_TYPE
import numpy as np
from .comm import chk_para_type

class Connection(object):
    
    def __init__(self,**kwargs):
        self.init_args = kwargs
        self.conn = None
        self.field = dict(
            [(getattr(FIELD_TYPE,i),i) for i in dir(FIELD_TYPE) \
                if type(getattr(FIELD_TYPE,i))==int])    
    
    def connect(self):
        self.conn =  pymysql.connect(
            host = self.init_args['host'], 
            port = self.init_args['port'], 
            user = self.init_args['user'], 
            passwd = self.init_args['passwd'], 
            db = self.init_args['db'], 
            charset = 'utf8')
        return self.conn

    def ping(self):
        try:
            conn = self.connect()
            conn.ping()
            return True
        except Exception as e:
            return False

    def sql_sampling(self,sql):
        curs = self.conn.cursor()
        curs.execute('select * from ({sql}) a limit 50'.format(sql=sql))
        col = [(i[0],self.field.get(i[1],'UNKOWN')) for i in curs.description]
        data = np.array(curs.fetchall()).T
        _lst = []
        for i in range(len(col)):
            _d = [k for k in set(data[i])]
            _lst.append({
                'field_name':col[i][0],
                'type'  : col[i][1],
                'sample': map(str,_d) if len(_d)<=5 else map(str,_d[:5])+['...'],
                'para_type': chk_para_type(_d)
            })
        return _lst

if __name__ == '__main__':
    conn = Connection(
        host='127.0.0.1', port=3306, user='root', passwd='root', db='ml', charset='utf8'
    )
    conn.ping()
    print conn.sql_sampling("select * from titanic")