<template>
  <h1>Active User</h1>
  <h2>UserName: {{ username }}</h2>
  <h3>Age: {{ age }}</h3>
</template>

<script>
  export default{
    props: {
      username: {
        type: String,
        required: true
      },
      age: {
        type: Number,
        required: true
      }
    }
  }
</script>