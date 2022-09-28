# ******************************************************************************
#
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#
# ******************************************************************************

import unittest
import xmlrunner
import os
from appium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.common.exceptions import NoSuchElementException
from time import sleep

calcAppName = "Calculator, App"


class CalculatorTest(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        global calcAppName
        desired_caps = {}
        desired_caps["app"] = "Root"
        self.driver = webdriver.Remote(
            command_executor='http://127.0.0.1:4723',
            desired_capabilities=desired_caps)

        self.searchCalculator(self)
        Calc = self.driver.find_element_by_xpath(
            "//*[contains(@Name,'Calculator')]")
        calcAppName = Calc.text

    @classmethod
    def tearDownClass(self):
        self.driver.quit()

    def setUp(self):
        os.system("taskkill /im Calculator.exe")

    def tearDown(self):
        try:
            self.searchCalculator()
            sleep(2)
            Calc = self.driver.find_element_by_name(calcAppName)
            ActionChains(self.driver).context_click(Calc).perform()
            self.driver.implicitly_wait(0.5)
            try:
                unpin = self.driver.find_element_by_accessibility_id(
                    'StartUnpin')
                unpin.click()
            except NoSuchElementException:
                print("Start Unpin Element does not exist")
            ActionChains(self.driver).context_click(Calc).perform()
            try:
                untaskpin = self.driver.find_element_by_accessibility_id(
                    'TaskbarUnpin')
                untaskpin.click()
            except NoSuchElementException:
                print("Taskbar Unpin Element does not exist")
            ActionChains(self.driver).send_keys(Keys.ESCAPE).perform()
        except:
            print("error tearDown")
        finally:
            self.driver.implicitly_wait(60)

    def searchCalculator(self):
        el = self.driver.find_element_by_name("Start")
        el.send_keys(Keys.META, 's')
        searchBox = self.driver.find_element_by_accessibility_id(
            "SearchTextBox")
        searchBox.clear()
        searchBox.send_keys('calculator')

    def test_createDesktop(self):
    # Case 1-1 : Create new desktop and Cascading App Windows
        el = self.driver.find_element_by_name("Start")
        el.send_keys(Keys.COMMAND, Keys.CONTROL, 'd')
        vds = self.driver.find_elements_by_xpath("/Pane[@Name=\"Desktop 2\"]")
        for vd in vds:
            print(vd.text)
        assert len(vds) == 1
        el.send_keys(Keys.COMMAND, Keys.TAB)
        self.driver.get_screenshot_as_file(self._testMethodName + '.png')
        el.send_keys(Keys.COMMAND, Keys.CONTROL, Keys.LEFT)
        el.send_keys(Keys.ESCAPE)
        el.send_keys(Keys.COMMAND, Keys.CONTROL, Keys.F4)

    def test_launchAppDiffViews(self):
    # Case 1-2 : Create new desktop : Launching Applications from different views
        el = self.driver.find_element_by_name("Start")
        el.send_keys(Keys.COMMAND, Keys.CONTROL, 'd')
        vd = self.driver.find_element_by_name("Desktop 2")
        assert vd != None
        self.searchCalculator()
        app = self.driver.find_element_by_name(calcAppName)
        app.click()
        sleep(2)
        self.driver.get_screenshot_as_file(self._testMethodName + '.png')
        el.send_keys(Keys.COMMAND, Keys.CONTROL, Keys.F4)

    def test_calcPinUnpin(self):
    # Case 2 : pin / unpin
        self.searchCalculator()
        Calc = self.driver.find_element_by_name(calcAppName)
        ActionChains(self.driver).context_click(Calc).perform()
        self.driver.find_element_by_accessibility_id('StartPin').click()
        ActionChains(self.driver).context_click(Calc).perform()
        self.driver.find_element_by_accessibility_id('TaskbarPin').click()
        ActionChains(self.driver).context_click(Calc).perform()
        ActionChains(self.driver).context_click(Calc).perform()
        self.driver.get_screenshot_as_file(self._testMethodName + '.png')
        unpin = self.driver.find_element_by_accessibility_id('StartUnpin')
        assert unpin != None
        unpin.click()
        ActionChains(self.driver).context_click(Calc).perform()
        untaskpin = self.driver.find_element_by_accessibility_id(
            'TaskbarUnpin')
        assert untaskpin != None
        untaskpin.click()
        ActionChains(self.driver).send_keys(Keys.ESCAPE).perform()

    def test_calculatorMin(self):
    # Case 3 : Restore/Minimize an application window
        self.searchCalculator()
        app = self.driver.find_element_by_name(calcAppName)
        app.click()
        sleep(2)
        windows = self.driver.find_elements_by_xpath(
            "/Pane[@Name=\"Desktop 1\"]/Pane[@ClassName=\"Chrome_WidgetWin_1\"][@Name=\"Calculator\"]/TitleBar[@AutomationId=\"TitleBar\"]/Button[@Name=\"Minimize\"]")
        windows[0].click()
        self.driver.find_element_by_name(
            "Calculator - 1 running window").click()
        self.driver.get_screenshot_as_file(self._testMethodName + '.png')

    def test_calculatorOpenTask(self):
    # Case 4 : Open calculator from taskbar
        self.searchCalculator()
        calc = self.driver.find_element_by_name(calcAppName)

        ActionChains(self.driver).context_click(calc).perform()
        self.driver.find_element_by_accessibility_id('TaskbarPin').click()
        ActionChains(self.driver).send_keys(Keys.ESCAPE).perform()
        sleep(5)
        taskBarCalc = self.driver.find_element_by_accessibility_id(
            "com.squirrel.calculator.calculator")
        assert taskBarCalc != None
        taskBarCalc.click()
        sleep(10)
        self.driver.get_screenshot_as_file(self._testMethodName + '.png')

    def test_switchApp(self):
    # Case 5 : Switching B/w Applications
        el = self.driver.find_element_by_name("Start")
        el.send_keys(Keys.ALT, Keys.TAB)
        self.driver.get_screenshot_as_file(self._testMethodName + '.png')

    def test_searchCalculator(self):
    # Case 6 : Search App by Windows Search and open it.
        self.searchCalculator()
        calc = self.driver.find_element_by_name(calcAppName)
        assert calc != None
        self.driver.get_screenshot_as_file(self._testMethodName + '.png')
        ActionChains(self.driver).send_keys(Keys.ESCAPE).perform()

if __name__ == '__main__':

    unittest.main(
        testRunner=xmlrunner.XMLTestRunner(output='test-reports'),
        failfast=False,
        buffer=False,
        catchbreak=False)