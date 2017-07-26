# -*- coding: utf-8 -*-

def chk_para_type(lst):
    for i in lst:
        try: 
            if i==None: pass
            else: float(i)
        except Exception :
            return 'str'
    return 'num'
        