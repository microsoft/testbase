//******************************************************************************
//
// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
//******************************************************************************

using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Appium.Windows;
using System.Threading;
using System;

namespace CalculatorTest
{
    [TestClass]
    public class ScenarioStandard : CalculatorSession
    {
        private static WindowsElement calculatorResult;

        [TestMethod]
        public void Addition()
        {
            // Find the buttons by their names and click them in sequence to perform 1 + 7 = 8
            session.FindElementByName("1").Click();
            session.FindElementByName("+").Click();
            session.FindElementByName("7").Click();
            session.FindElementByName("=").Click();

            Assert.AreEqual("8", GetCalculatorResultText());
        }

        [TestMethod]
        public void Division()
        {
            // Find the buttons by their names using XPath and click them in sequence to perform 88 / 11 = 8
            session.FindElementByXPath("//Button[@Name='8']").Click();
            session.FindElementByXPath("//Button[@Name='8']").Click();
            session.FindElementByXPath("//Button[@Name='÷']").Click();
            session.FindElementByXPath("//Button[@Name='1']").Click();
            session.FindElementByXPath("//Button[@Name='1']").Click();
            session.FindElementByXPath("//Button[@Name='=']").Click();
            Assert.AreEqual("8", GetCalculatorResultText());
        }

        [TestMethod]
        public void Multiplication()
        {
            // Find the buttons by their names using XPath and click them in sequence to perform 9 x 9 = 81
            session.FindElementByXPath("//Button[@Name='9']").Click();
            session.FindElementByXPath("//Button[@Name='x']").Click();
            session.FindElementByXPath("//Button[@Name='9']").Click();
            session.FindElementByXPath("//Button[@Name='=']").Click();
            Assert.AreEqual("81", GetCalculatorResultText());
        }

        [TestMethod]
        public void Subtraction()
        {
            // Find the buttons by their names using XPath and click them in sequence to perform 9 - 1 = 8
            session.FindElementByXPath("//Button[@Name='9']").Click();
            session.FindElementByXPath("//Button[@Name='-']").Click();
            session.FindElementByXPath("//Button[@Name='1']").Click();
            session.FindElementByXPath("//Button[@Name='=']").Click();
            Assert.AreEqual("8", GetCalculatorResultText());
        }

        [TestMethod]
        [DataRow("1",   "+",      "7", "8")]
        [DataRow("9",  "-",     "1",   "8")]
        [DataRow("8", "÷", "8", "1")]
        public void Templatized(string input1, string operation, string input2, string expectedResult)
        {
            // Run sequence of button presses specified above and validate the results
            session.FindElementByName(input1).Click();
            session.FindElementByName(operation).Click();
            session.FindElementByName(input2).Click();
            session.FindElementByName("=").Click();
            Assert.AreEqual(expectedResult, GetCalculatorResultText());
        }

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            // Create session to launch a Calculator window
            Setup(context);
            Thread.Sleep(TimeSpan.FromSeconds(1));
            //// Locate the calculatorResult element
            calculatorResult = session.FindElementByXPath("//Text");
            Assert.IsNotNull(calculatorResult);
        }

        [ClassCleanup]
        public static void ClassCleanup()
        {
            TearDown();
        }

        [TestInitialize]
        public void Clear()
        {
            session.FindElementByName("C").Click();
            Assert.AreEqual("0", GetCalculatorResultText());
        }

        private string GetCalculatorResultText()
        {
            return session.FindElementByXPath("//Text").Text.Trim();
        }
    }
}
