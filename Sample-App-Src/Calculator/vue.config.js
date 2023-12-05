/*---------------------------------------------------------------------------------------------
* Copyright (c) Microsoft Corporation. All rights reserved.
* Licensed under the MIT License.
*--------------------------------------------------------------------------------------------*/
module.exports = {
  transpileDependencies:true,
  pluginOptions: {
    electronBuilder: {
      nodeIntegration: true,
      builderOptions:{
        extraFiles: [
        {from:'./CalculatorCLI/drop',to:'./'}],
      }
    }
  },
};
