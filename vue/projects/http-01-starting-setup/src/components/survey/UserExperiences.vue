<template>
  <section>
    <base-card>
      <h2>Submitted Experiences</h2>
      <div>
        <base-button @click="loadExperences"
          >Load Submitted Experiences</base-button
        >
      </div>
      <!-- an error in an if chain directs to the top of the chain -->
      <p v-if="isLoading">Loading...</p>
      <p v-else-if="error">There was an error. Please try again later.</p>
      <p v-else-if="(!results || results.length === 0)">No stored experences found. Start adding some survey results first</p>
      <ul v-else-if="!isLoading && results && results.length > 0">
        <survey-result
          v-for="result in results"
          :key="result.id"
          :name="result.name"
          :rating="result.rating"
        ></survey-result>
      </ul>
    </base-card>
  </section>
</template>

<script>
import SurveyResult from './SurveyResult.vue';

export default {
  components: {
    SurveyResult,
  },
  data() {
    return {
      results: [],
      isLoading: false,
      error: null
    };
  },
  methods: {
    loadExperences() {
      this.isLoading = true
      fetch(
        'https://vue-http-demo-d1373-default-rtdb.firebaseio.com/sueveys.json'
      )
        .then((response) => {//arrow functions allow you to reffer to the parent functions "this" keyword
          if (response.ok) {
            return response.json();
          }
        })
        .then((data) => {
          this.isLoading = false;
          const results = [];
          for (const id in data) {
            results.push({
              id: id,
              name: data[id].name,
              rating: data[id].rating,
            });
            this.results = results;
          }
        }).catch(()=>{
          this.isLoading = false;
          this.error = 'Failed to fetch data. Please try again later.';
        });
    },
  },
  mounted() {
    this.loadExperences()
  }
};
</script>

<style scoped>
ul {
  list-style: none;
  margin: 0;
  padding: 0;
}
</style>