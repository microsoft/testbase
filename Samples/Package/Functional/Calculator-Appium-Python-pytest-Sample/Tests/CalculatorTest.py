#******************************************************************************
#
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#
#******************************************************************************

import pytest
from appium import webdriver
import time, os
from time import sleep

class TestCalculator:
    
    @classmethod
    def setup_class(self):
        #set up appium
        desired_caps = {}
        desired_caps["app"] = "C:\Program Files (x86)\Calculator\calculator.exe"
        self.driver = webdriver.Remote(
            command_executor='http://127.0.0.1:4723',
            desired_capabilities= desired_caps)
    
    @classmethod
    def teardown_class(self):
        self.driver.quit()

    def getresults(self):
        displaytext = self.driver.find_element_by_xpath('//Text').text
        displaytext = displaytext.rstrip(' ')
        displaytext = displaytext.lstrip(' ')
        return displaytext

    def test_addition(self):
        time.sleep(5)
        self.driver.find_element_by_xpath("//Button[@Name='C']").click()
        self.driver.find_element_by_xpath("//Button[@Name='1']").click()
        self.driver.find_element_by_xpath("//Button[@Name='+']").click()
        self.driver.find_element_by_xpath("//Button[@Name='7']").click()
        self.driver.find_element_by_xpath("//Button[@Name='=']").click()
        assert self.getresults() == "8"

    def test_minus(self):
        time.sleep(5)
        self.driver.find_element_by_xpath("//Button[@Name='C']").click()
        self.driver.find_element_by_xpath("//Button[@Name='1']").click()
        self.driver.find_element_by_xpath("//Button[@Name='1']").click()
        self.driver.find_element_by_xpath("//Button[@Name='-']").click()
        self.driver.find_element_by_xpath("//Button[@Name='2']").click()
        self.driver.find_element_by_xpath("//Button[@Name='=']").click()
        assert self.getresults() == "9"

    def test_multiply(self):
        time.sleep(5)
        self.driver.find_element_by_xpath("//Button[@Name='C']").click()
        self.driver.find_element_by_xpath("//Button[@Name='5']").click()
        self.driver.find_element_by_xpath("//Button[@Name='x']").click()
        self.driver.find_element_by_xpath("//Button[@Name='6']").click()
        self.driver.find_element_by_xpath("//Button[@Name='=']").click()
        assert self.getresults() == "30"
