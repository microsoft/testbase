/*---------------------------------------------------------------------------------------------
* Copyright (c) Microsoft Corporation. All rights reserved.
* Licensed under the MIT License.
*--------------------------------------------------------------------------------------------*/
import App from './App.vue'
import * as VueRouter from 'vue-router'
import { createApp } from 'vue/dist/vue.esm-bundler';

import Cal from './components/Calculator.vue'

const routes = [
  { path: '/', component: Cal },
]

const router = VueRouter.createRouter({
  history: VueRouter.createWebHashHistory(),
  routes, 
})

createApp(App).use(router).mount("#app")
