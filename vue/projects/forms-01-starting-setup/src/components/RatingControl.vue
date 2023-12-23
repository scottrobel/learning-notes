<template>
  <ul>
    <li :class="{active: activeOption == 'poor'}"><button type="button" @click="activate('poor')">Poor</button></li>
    <li :class="{active: activeOption == 'average'}"><button type="button"  @click="activate('average')">Average</button></li>
    <li :class="{active: activeOption == 'great'}"><button type="button"  @click="activate('great')">Great</button></li>
  </ul>
</template>

<script>
export default({
  //v-model on a component creates the modelValue prop and listens for an update:modelValue event
  //on the parent element
  props: ['modelValue'],
  emits: ['update:modelValue'],
  data() {
    return {
    }
  },
  computed: {
    activeOption(){
      return this.modelValue;
    }
  },
  methods: {
    activate(option){
      this.$emit('update:modelValue', option);
    }
  }
})
</script>

<style scoped>
.active {
  border-color: purple;
}

.active button{
  color:  purple;
}

ul {
  list-style: none;
  margin: 0.5rem 0;
  padding: 0;
  display: flex;
}
li {
  margin: 0 1rem;
  border: 1px solid #ccc;
  display: flex;
  justify-content: center;
}
button {
  font: inherit;
  border: none;
  background-color: transparent;
  cursor: pointer;
}
</style>