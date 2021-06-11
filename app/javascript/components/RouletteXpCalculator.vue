<template>
  <b-container>
    <b-form>
      <label for='start_level'>Start Level</label>
      <b-form-input id='start_level' required v-model="start_level" />

      <label for='start_xp'>Start XP</label>
      <b-form-input id='start_xp' required v-model="start_xp" />

      <b-form-group label="Roulettes to Run">
        <b-form-checkbox-group stacked v-model='rouletteSelected' :options="roulettes">
        </b-form-checkbox-group>
      </b-form-group>

      <b-btn @click="calculate()" class='my-2' variant='info'>Math me!</b-btn>
      <b-btn @click="calculate(true)" disabled class='my-2' variant='info'>Math me to the max!</b-btn>
    </b-form>

    <section v-if='rouletteSuggestions'>
      <div v-for="day in Object.keys(rouletteSuggestions)" :key="day">
        <h3 v-if="Object.keys(rouletteSuggestions).length !== 1">Day {{day}}</h3>
        <b-card v-for="level in Object.keys(rouletteSuggestions[day])" :key="level" :title="'Level ' + level">
          <b-card-text>
            <b-table :items="rouletteSuggestions[day][level]" />
          </b-card-text>
        </b-card>
        <hr />
      </div>
    </section>
  </b-container>
</template>

<script>
  import axios from 'axios';
  export default {
    props: {
      roulettes: {
        type: Array,
        default: () => [],
      }
    },
    mounted() {
      this.rouletteSelected = this.roulettes;
    },
    data() {
      return {
        start_level: 1,
        start_xp: 0,
        rouletteSelected: [],
        estimated_level: 0,
        estimated_xp: 0,
        rouletteSuggestions: undefined,
      };
    },
    methods: {
      calculate(max = false) {
        axios({
          method: 'post',
          headers: { 'Content-Type': 'text/json' },
          url: '/metrics/roulette_calculator',
          data: {
            start_level: this.start_level,
            start_xp: this.start_xp,
            roulettes: this.rouletteSelected,
            to_max: max
          }
        }).then((response) => {
          let data = response.data;
          this.estimated_level = data.estimated_level;
          this.estimated_xp = data.estimated_xp;
          data.delete(data.estimated_level)
          data.delete(data.estimated_xp)
          this.rouletteSuggestions = data;
        })
      },
    },
  };
</script>

<style scoped>

</style>
