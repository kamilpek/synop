#!/usr/bin/env python
# encoding: utf8
# Kamil Pek (C)18.02.2018
# nohup /root/synop/start_imports_synop.py &
# nohup python start_imports_synop.py

import os
import schedule
import time

def yrno():
    os.system("sudo docker exec synop_app_1 rake import_yrno RAILS_ENV=production")

def imgw():
    os.system("sudo docker exec synop_app_1 rake import_imgw_xml RAILS_ENV=production")

def planer():
    schedule.every().day.at("09:00").do(yrno)
    schedule.every().hour.do(imgw)

def test():
    yrno()
    imgw()

planer()

# test()

while True:
    schedule.run_pending()
    time.sleep(1)
