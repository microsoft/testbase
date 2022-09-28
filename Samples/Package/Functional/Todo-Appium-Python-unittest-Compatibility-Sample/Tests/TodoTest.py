#******************************************************************************
#
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#
#******************************************************************************

import unittest
import xmlrunner
from appium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from time import sleep

class TodoTest(unittest.TestCase):
        TodoAppid = None
        @classmethod

        def setUpClass(self):
            TodoTest.TodoAppid = 'Microsoft.Todos_8wekyb3d8bbwe!App'
            desired_caps = {}
            desired_caps["app"] = "Root"
            self.driver = webdriver.Remote(
                command_executor='http://127.0.0.1:4723',
                desired_capabilities= desired_caps)

        @classmethod

        def tearDownClass(self):
            self.driver.quit()

        def test_createDesktop(self):
        # Case 1-1 : Create new desktop and Cascading App Windows
            # Create a new virtual Desktop (Win+Ctrl+D)
            ActionChains(self.driver).key_down(Keys.CONTROL).key_down(Keys.COMMAND).send_keys('d').key_up(Keys.COMMAND).key_up(Keys.CONTROL).perform()
            # Enter the interface where you can switch desktops (Win+Tab)
            ActionChains(self.driver).key_down(Keys.COMMAND).key_down (Keys.TAB).key_up(Keys.TAB).key_up(Keys.COMMAND).perform()
            # Save the screenshot as png file
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            # Switch the left desktop (Win+Ctrl+left)
            ActionChains(self.driver).key_down(Keys.COMMAND).key_down(Keys.CONTROL).key_down(Keys.LEFT).key_up(Keys.LEFT).key_up(Keys.COMMAND).key_up(Keys.CONTROL).perform()
            # Enter the selected desktop (ESC)
            ActionChains(self.driver).key_down(Keys.ESCAPE).key_up(Keys.ESCAPE).perform()
            # Delete the new destop (Win+Ctrl+F4)
            ActionChains(self.driver).key_down(Keys.COMMAND).key_down(Keys.CONTROL).key_down(Keys.F4).key_up(Keys.F4).key_up(Keys.CONTROL).key_up(Keys.COMMAND).perform()

        def test_launchappdifviews(self):
        # Case 1-2 : Create new desktop : Launching Applications from different views
            # Create a new virtual Desktop (Win+Ctrl+D)
            ActionChains(self.driver).key_down(Keys.CONTROL).key_down(Keys.COMMAND).send_keys('d').key_up(Keys.COMMAND).key_up(Keys.CONTROL).perform()
            self.driver.find_element_by_name("Start").click()
            self.driver.find_element_by_name("Start").send_keys("To Do",Keys.ENTER)
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            # Delete the current destop (Win+Ctrl+F4)
            ActionChains(self.driver).key_down(Keys.COMMAND).key_down(Keys.CONTROL).key_down(Keys.F4).key_up(Keys.F4).key_up(Keys.CONTROL).key_up(Keys.COMMAND).perform()

        def test_todopin(self):
        # Case 2 : pin / unpin / Rate & Review
            el = self.driver.find_element_by_name("Start");
            el.send_keys(Keys.META,'s');
            searchBox = self.driver.find_element_by_accessibility_id("SearchTextBox");
            searchBox.send_keys('to do')
            Todo = self.driver.find_element_by_name("Microsoft To Do, App, Press right to switch preview")
            ActionChains(self.driver).context_click(Todo).perform();
            self.driver.find_element_by_accessibility_id('StartPin').click()
            ActionChains(self.driver).context_click(Todo).perform();
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            unpin = self.driver.find_element_by_accessibility_id('StartUnpin')
            assert unpin!=None
            unpin.click()
            ActionChains(self.driver).context_click(Todo).perform();
            self.driver.find_element_by_accessibility_id('TaskbarPin').click()
            ActionChains(self.driver).context_click(Todo).perform();
            untaskpin = self.driver.find_element_by_accessibility_id('TaskbarUnpin')
            assert untaskpin!=None
            untaskpin.click()
            ActionChains(self.driver).context_click(Todo).perform();
            self.driver.find_element_by_accessibility_id('Review').click()
            sleep(5)

        def test_todorestore(self):
        # Case 3 : Restore/Maximize/Minimize an application window
            self.driver.find_element_by_name("Start").click()
            self.driver.find_element_by_name("Start").send_keys("To Do",Keys.ENTER)
            self.driver.find_element_by_accessibility_id("Maximize").click()
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            self.driver.find_element_by_accessibility_id("Minimize").click()
            self.driver.find_element_by_accessibility_id(TodoTest.TodoAppid).click()
            sleep(5)

        def test_todoopentask(self):
        # Case 4 : Open todo and close it from taskbar
            el = self.driver.find_element_by_name("Start");
            el.send_keys(Keys.META,'s');
            searchBox = self.driver.find_element_by_accessibility_id("SearchTextBox");
            searchBox.send_keys('to do')
            Todo = self.driver.find_element_by_name("Microsoft To Do, App, Press right to switch preview")
            ActionChains(self.driver).context_click(Todo).perform();
            self.driver.find_element_by_accessibility_id('TaskbarPin').click()
            Todo = self.driver.find_element_by_accessibility_id(TodoTest.TodoAppid)
            self.driver.find_element_by_accessibility_id(TodoTest.TodoAppid).click()
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            sleep(4)
            ActionChains(self.driver).context_click(Todo).perform()
            self.driver.find_element_by_accessibility_id("Close").click()
            el.send_keys(Keys.META,'s');
            searchBox.send_keys('to do')
            Todo = self.driver.find_element_by_name("Microsoft To Do, App, Press right to switch preview")
            ActionChains(self.driver).context_click(Todo).perform();
            self.driver.find_element_by_accessibility_id('TaskbarUnpin').click()
            searchBox.clear()
            sleep(5)
        
        def test_todoappsettings(self):
        # Case 5 : Open App Settings
            el = self.driver.find_element_by_name("Start");
            el.send_keys(Keys.META,'s');
            searchBox = self.driver.find_element_by_accessibility_id("SearchTextBox");
            searchBox.send_keys('to do')
            Todo = self.driver.find_element_by_name("Microsoft To Do, App, Press right to switch preview")
            ActionChains(self.driver).context_click(Todo).perform();
            appsettings =self.driver.find_element_by_accessibility_id('Settings');
            appsettings.click();
            sleep(6)
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')

        def test_todoterm(self):
        # Case 6 : Terminate and Reset App (after Open App Settings)
            el = self.driver.find_element_by_name("Start");
            el.send_keys(Keys.META,'s');
            searchBox = self.driver.find_element_by_accessibility_id("SearchTextBox");
            searchBox.send_keys('to do')
            Todo = self.driver.find_element_by_name("Microsoft To Do, App, Press right to switch preview")
            ActionChains(self.driver).context_click(Todo).perform();
            appsettings =self.driver.find_element_by_accessibility_id('Settings');
            appsettings.click();
            self.driver.find_element_by_accessibility_id("SystemSettings_StorageSense_AppSizesAdvanced_AppTerminate_Button").click();
            sleep(40)
            self.driver.find_element_by_accessibility_id('SystemSettings_StorageSense_AppSizesAdvanced_AppReset_Button').click();
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            self.driver.find_element_by_accessibility_id('SystemSettings_StorageSense_AppSizesAdvanced_AppReset_ConfirmButton').click();
            sleep(5)

        def test_switchapp(self):
        # Case 7 : Switching B/w Applications
            ActionChains(self.driver).key_down(Keys.ALT).key_down (Keys.TAB).key_up(Keys.TAB).perform()
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            ActionChains(self.driver).key_up(Keys.ALT).perform()
            sleep(5)

        def test_searchtodo(self):
        # Case 8: Search App by Windows Search and open it.
            self.driver.find_element_by_name("Start").click()
            self.driver.find_element_by_name("Start").send_keys("To Do")
            self.driver.get_screenshot_as_file(self._testMethodName +'.png')
            self.driver.find_element_by_name("Microsoft To Do, App, Press right to switch preview").click()
            sleep(5)

if __name__ == '__main__':

    unittest.main(
        testRunner=xmlrunner.XMLTestRunner(output='test-reports'),
        failfast=False,
        buffer=False,
        catchbreak=False)