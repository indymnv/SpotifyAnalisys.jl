using HTTP
using Gumbo
using Cascadia
using PyCall
using Conda
Conda.add("Selenium")

selenium = pyimport("selenium")

py"""
import time
from selenium import webdriver

driver = webdriver.Chrome("../14-spotify/chromedriver")
driver.get("http://aplicativos.odepa.cl/recepcion-industria-lactea.do")

time.sleep(10)

driver.quit()
"""

driver.get("http://aplicativos.odepa.cl/recepcion-industria-lactea.do")


function get_page(url)
    response = HTTP.get("http://resumen.cbv.cl/")
    return response.body
end

get_page("http://resumen.cbv.cl/")
