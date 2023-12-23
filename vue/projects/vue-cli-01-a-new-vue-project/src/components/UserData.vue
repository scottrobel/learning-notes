<template>
  <h2>User Data</h2>
  <form @submit.prevent="updateUser">
    <label>Age</label>
    <input type="text" v-model="age" placeholder="Your Age">
    <label>Name</label>
    <input type="text" v-model="name" placeholder="Your Name">
    <button>Set User Data</button>
  </form>
</template>

<script>
  export default{
    emits: ['user-updated'],
    data(){
      return {
        name: '',
        age: ''
      }
    },
    methods: {
      updateUser(){
        this.$emit('user-updated', this.name, this.age)
      }
    }
  }
</script>