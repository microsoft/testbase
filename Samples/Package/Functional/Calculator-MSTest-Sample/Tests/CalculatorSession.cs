//******************************************************************************
//
// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
//******************************************************************************

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics;

namespace CLITest
{
    public class CalculatorSession
    {
        // Note: append /wd/hub to the URL if you're directing the test at Appium
        private const string CalculatorCLI = @"C:\Program Files (x86)\Calculator\app-0.1.0\CalculatorCLI.exe";

        protected static Process session;

        public static void Setup(TestContext context)
        {
            // Launch Calculator application if it is not yet launched
            if (session == null)
            {
                session = new Process();
                session.StartInfo.UseShellExecute = false;
                session.StartInfo.RedirectStandardOutput = true;
                session.StartInfo.FileName = CalculatorCLI;
            }
        }

        public static void TearDown()
        {
            // Close the application and delete the session
            if (session != null)
            {
                session.Close();
                session = null;
            }
        }
    }
}
