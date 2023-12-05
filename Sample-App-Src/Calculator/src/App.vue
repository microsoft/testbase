<template>
  <div class="app">
  <!-- route outlet -->
  <!-- component matched by the route will render here -->
  <router-view class= "mainbox"></router-view>
  </div>
</template>



<script>

export default {
  name: 'App',
  components: {
  }
}
</script>

<style>
html{
  font-family: Helvetica, sans-serif;
  height: 100%;
  -webkit-font-smoothing: antialiased;
}
.app{
  text-align: center;
  color: #2c3e50;
  margin-top: 2px;
  height: 100%;
  display: flex;
}
.content{
  display: flex;
}
.menu{
  width: 100px;
  height:auto;
  margin-right: 30px;
}
.submenu{
  height: 50px;
  line-height: 50px;
}
.mainbox{
  flex : 1
}

</style>
