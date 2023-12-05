<template>
  <div>
   <div class="displayformula"><input v-model="formula" disabled/></div>
   <div class="calculator">
    <div class="display">{{current || 0}}</div>
    <button @click = "clear" class="ac">C</button>
    <button @click = "sign" class="ac">+/-</button>
    <button @click = "perc" class="ac">%</button>
    <button @click = 'divide' class="act">÷</button>
    <button @click = "append('7')" class="num">7</button>
    <button @click = "append('8')" class="num">8</button>
    <button @click = "append('9')" class="num">9</button>
    <button @click = "ride" class="act">x</button>
    <button @click = "append('4')" class="num">4</button>
    <button @click = "append('5')" class="num">5</button>
    <button @click = "append('6')" class="num">6</button>
    <button @click = "minus" class="act">-</button>
    <button @click = "append('1')" class="num">1</button>
    <button @click = "append('2')" class="num">2</button>
    <button @click = "append('3')" class="num">3</button>
    <button @click = "plus" class="act">+</button>
    <button @click = "appendzero" class="zero">0</button>
    <button @click = "dot" class="num">.</button>
    <button @click = "equal" class="act">=</button>
   </div>
  </div>
</template>

<script>
export default {
 data( ) {
   return {
     current: '',
     previous: null,
     operate: null,
     operateClicked: false,
     formula: ' ',
   }
 },
 methods:{
   nextact(act){
      this.current = `${this.oldoperate(
       parseFloat(this.previous),
       parseFloat(this.current)
     )}`;
     this.formula = this.current + ' ' + act;
     this.operateClicked = true;
     this.previous = this.current;
     this.actbefore = false;
   },
   formulaupdate(act)
   {
     if(this.actbefore && act != '='){
       this.nextact(act);
     }else{
        if(this.current === '')
        {
          this.formula = this.formula + ' '
        }else
        {
            this.formula = this.formula + ' ' + this.current + ' ' + act;
        }
      }
   },
   clear(){
     this.current = '';
     this.previous = null;
     this.operate = null;
     this.oldoperate = null;
     this.operateClicked = false;
     this.actbefore = false;
     this.formula = '';
   },
   sign (){
     this.current = this.current.charAt(0) === '-' ? this.current.slice(1) : `-${this.current}`;
   },
   perc(){
     this.current = `${parseFloat(this.current)/100}`
   },
   append(number){
     if (this.operateClicked){
       this.current = '';
       this.operateClicked = false
     }
     this.current = `${(this.current)}${(number)}`
   },
   appendzero(){
     this.current = this.current === '' ? '': `${(this.current)}0`
   },
   dot(){
     if( this.current.indexOf('.') === -1)
     {
       this.append('.')
     }
   },
   setprevious()
   {
     this.previous = this.current;
     this.operateClicked = true;
     this.actbefore = true;
   }
   ,
   divide() {
     this.oldoperate = this.operate;
     this.operate = (a,b) => a / b;
     this.formulaupdate('÷')
     if(!this.actbefore){
       this.setprevious();
     }
   },
   ride() {
     this.oldoperate = this.operate;
     this.operate = (a,b) => a * b;
     this.formulaupdate('x')
     if(!this.actbefore){
       this.setprevious();
     }
   },
   plus(){
     this.oldoperate = this.operate;
     this.operate = (a,b) => a + b;
     this.formulaupdate('+')
     this.setprevious();

   },
   minus(){
     this.oldoperate = this.operate;
     this.operate = (a,b) => a - b;
     this.formulaupdate('-')
     this.setprevious();

   },
   equal(){
     this.formulaupdate('=')
     this.current = `${this.operate(
       parseFloat(this.previous),
       parseFloat(this.current)
     )}`

   }
 }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.about
{
  color: black;
  line-height:30px;
  text-decoration:none;
  margin-right:90%;
}
.calculator{
  font-size:20px;
  line-height: 80px;
  display:grid;
  grid-template-columns: repeat(4,lfr);
  grid-auto-rows:minmax(80px,auto)
}
.displayformula
{
  grid-column: 1/5;
  background-color: #E0E0E0;
  color: black;
  text-align: right;
  padding-right: 20px;
  height: 40px;
  line-height:45px;
  border: true;
  Margin-top:-8px;
}
.displayformula input{
  padding: 0;
  margin: 0;
  border: 0;
  background-color: rgb(0,0,0,0);
  text-align: right
}
.display{
  grid-column: 1/5;
  background-color: #E0E0E0;
  color: black;
  text-align: right;
  padding-right: 20px;
  font-size: 60px;
}
.ac {
  line-height: center;
  background-color: #4F4F4F;
  color: white;
  border: 1px solid #333;
  font-size: 25px;
}
.zero{
  grid-column: 1/3;
  background-color: #4F4F4F;
  color: white;
  border: 1px solid #333;
  font-size: 25px;
}
.act{
  background-color: #6CA6CD ;
  color: white;
   border: 1px solid #333;
   font-size: 25px;
}
.num{
  background-color: #4F4F4F;
  color: white;
  border: 1px solid #333;
  font-size: 25px;
}
</style>
