<template>
  <active-user
  :username="user.username"
  :age="user.age"
  ></active-user>
  <user-data
  @user-updated="updateUser"></user-data>
</template>

<script>
  import ActiveUser from './components/ActiveUser.vue';
  import UserData from './components/UserData.vue'
  export default{
    components: {ActiveUser, UserData},
    data(){
      return {
        user: {
          username: 'Scott Robel',
          age: 17
        }
      }
    },
    methods: {
      updateUser(name, Userage){
        this.user.username = name,
        this.user.age = +Userage
      }
    }
  }
</script>
