//******************************************************************************
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
//******************************************************************************

import org.junit.*;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;
import java.util.concurrent.TimeUnit;
import java.net.URL;
import io.appium.java_client.windows.WindowsDriver;

public class CalculatorTest {

    private static WindowsDriver CalculatorSession = null;

    @BeforeClass
    public static void setup() {
        try {
            DesiredCapabilities capabilities = new DesiredCapabilities();
            capabilities.setCapability("app", "C:\\Program Files (x86)\\Calculator\\calculator.exe");
            CalculatorSession = new WindowsDriver(new URL("http://127.0.0.1:4723"), capabilities);
            CalculatorSession.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
            CalculatorSession.findElementByXPath("//Text");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

        }
    }

    @Before
    public void Clear() {
        CalculatorSession.findElementByXPath("//Button[@Name='C']").click();
        Assert.assertEquals("0", _GetCalculatorResultText());
    }

    @AfterClass
    public static void TearDown() {
        if (CalculatorSession != null) {
            CalculatorSession.quit();
        }
        CalculatorSession = null;
    }

    @Test
    public void Addition() {
        CalculatorSession.findElementByXPath("//Button[@Name='1']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='+']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='7']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='=']").click();
        Assert.assertEquals("8", _GetCalculatorResultText());
    }

    @Test
    public void Minus() {
        CalculatorSession.findElementByXPath("//Button[@Name='1']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='1']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='-']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='2']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='=']").click();
        Assert.assertEquals("9", _GetCalculatorResultText());

    }

    @Test
    public void Division() {
        CalculatorSession.findElementByXPath("//Button[@Name='5']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='x']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='6']").click();
        CalculatorSession.findElementByXPath("//Button[@Name='=']").click();
        Assert.assertEquals("30", _GetCalculatorResultText());
    }

    protected String _GetCalculatorResultText() {
        // trim whitespace off of the display value
        return CalculatorSession.findElementByXPath("//Text").getText().trim();
    }
}
