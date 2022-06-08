/*---------------------------------------------------------------------------------------------
* Copyright (c) Microsoft Corporation. All rights reserved.
* Licensed under the MIT License.
*--------------------------------------------------------------------------------------------*/

// 1. Import Modules
const { MSICreator } = require('electron-wix-msi');
const path = require('path');

// 2. Define input and output directory.
// Important: the directories must be absolute, not relative e.g
// appDirectory: "dist_electron/win-unpacked",
const APP_DIR = path.resolve(__dirname,'./dist_electron/win-unpacked');
// outputDirectory: "./windows_installer",
const OUT_DIR = path.resolve(__dirname,'./windows_installer');

const ICON_File =path.resolve(__dirname,'./public/favicon.ico');

// 3. Instantiate the MSICreator
const msiCreator = new MSICreator({
    appDirectory: APP_DIR,
    outputDirectory: OUT_DIR,
    appIconPath: ICON_File,
    // Configure metadata
    description: 'This is a demo application',
    exe: 'calculator',
    name: 'Calculator',
    manufacturer: 'Microsoft',
    version: '0.1.0',

    // Configure installer User Interface
    ui: {
        chooseDirectory: true
    },
});

// 4. Create a .wxs template file
msiCreator.create().then(function(){

    // Step 5: Compile the template to a .msi file
    msiCreator.compile();
});