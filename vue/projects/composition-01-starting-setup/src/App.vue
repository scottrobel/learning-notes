<template>
  <section class="container">
    <h2>{{ user.name }}</h2>
    <h2 @click="increaseAge">{{ user.age }}</h2>
    <button @click="increaseAge">Increase age</button>
  </section>
</template>

<script setup>
import { reactive } from 'vue';
const user = reactive({name: 'Maximilian', age: 31})
function increaseAge(){
  user.age  += 1;
}
</script>

<style>
* {
  box-sizing: border-box;
}

html {
  font-family: sans-serif;
}

body {
  margin: 0;
}

.container {
  margin: 3rem auto;
  max-width: 30rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);
  padding: 1rem;
  text-align: center;
}
</style>