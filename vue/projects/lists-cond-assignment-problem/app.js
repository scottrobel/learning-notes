const app = Vue.createApp({
  data: function(){
    return {
      task: '',
      taskList: [],
      showList: true
    }
  },
  methods: {
    addTask: function(){
      this.taskList.push(this.task)
    },
    toggleList: function(){
      this.showList = !this.showList
    }
  }
});
app.mount('#assignment')