using HTTP
using Gumbo
using Cascadia
using PyCall
using Conda
#Conda.add("Selenium")

selenium = pyimport("selenium")

py"""
import time
from selenium import webdriver

driver = webdriver.Chrome("../14-spotify/chromedriver")
driver.get("http://resumen.cbv.cl/")

time.sleep(10)

driver.quit()
"""



