//******************************************************************************
//
// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
//******************************************************************************

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Threading;
using System;

namespace CLITest
{
    [TestClass]
    public class ScenarioStandard : CalculatorSession
    {

        [TestMethod]
        public void Addition()
        {
            session.StartInfo.Arguments = "1+7";
            session.Start();
            Assert.AreEqual("8", GetCalculatorResultText());
        }

        [TestMethod]
        public void Division()
        {
            session.StartInfo.Arguments = "88/11";
            session.Start();
            Assert.AreEqual("8", GetCalculatorResultText());
        }

        [TestMethod]
        public void Multiplication()
        {
            session.StartInfo.Arguments = "9*9";
            session.Start();
            Assert.AreEqual("81", GetCalculatorResultText());
        }

        [TestMethod]
        public void Subtraction()
        {
            session.StartInfo.Arguments = "9-1";
            session.Start();
            Assert.AreEqual("8", GetCalculatorResultText());
        }

        [TestMethod]
        [DataRow("1",   "+",      "7", "8")]
        [DataRow("9",  "-",     "1",   "8")]
        [DataRow("8", "/", "8", "1")]
        public void Templatized(string input1, string operation, string input2, string expectedResult)
        {
            // Run sequence of button presses specified above and validate the results
            var input = $"{input1}{operation}{input2}";
            session.StartInfo.Arguments = input;
            session.Start();
            Assert.AreEqual(expectedResult, GetCalculatorResultText());
        }

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            // Create session to launch a Calculator window
            Setup(context);
            Thread.Sleep(TimeSpan.FromSeconds(1));
        }

        [ClassCleanup]
        public static void ClassCleanup()
        {
            TearDown();
        }

        private string GetCalculatorResultText()
        {
            return session.StandardOutput.ReadToEnd();
        }
    }
}
