# -*- coding: utf-8 -*-
"""
http://stackoverflow.com/questions/42210901/pyhive-sqlalchemy-can-not-connect-to-hadoop-sandbox
pip install thrift
pip install PyHive
conda install sasl
pip install thrift-sasl
anaconda search thrift_sasl
conda install --channel https://conda.anaconda.org/conda-forge thrift_sasl
conda install --channel https://conda.anaconda.org/blaze thrift_sasl
"""
# from impala.util import as_pandas
# from impala.dbapi import connect

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
            "hive://{user}:{passwd}@{host}:{port}/{db}".format(
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
        curs = self.conn.execute('select * from ({sql}) a limit 50'.format(sql=sql))
        # i[0][2:] hive接口给的列名是 a.col 的格式 需要手工剔除掉
        col = [(i[0][2:],i[1]) for i in curs.cursor.description] 
        data = np.array(curs.fetchall()).T
        _lst = []
        for i in range(len(col)):
            _d = [k for k in set(data[i])]
            _lst.append({
                'field_name':col[i][0].lower(), #某些数据库字段是大写, pandas 加载是小写 ,这里默认都强制转换成小写
                'type'  : col[i][1],
                'sample': map(str,_d) if len(_d)<=5 else map(str,_d[:5])+['...'],
                'para_type': chk_para_type(_d)
            })
        curs.close()
        return _lst


# import pyhs2
# conn = pyhs2.connect(host='192.168.1.231',
#     port=10000,
#     authMechanism="PLAIN",
#     user='hadoop',
#     password='123123',
#     database='default')
# curs = conn.cursor()
# curs.execute("select * from (select row_names,pclass,survived,age,embarked,sex from titanic) a limit 50")
# curs.getSchema()
