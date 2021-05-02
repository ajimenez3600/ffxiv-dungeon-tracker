<template>
  <b-container>
    <b-form @submit=calculate>
      <label for='start_level'>Start Level</label>
      <b-form-input id='start_level' required v-model="start_level" />

      <label for='start_xp'>Start XP</label>
      <b-form-input id='start_xp' required v-model="start_xp" />

      <b-form-group label="Roulettes to Run">
        <b-form-checkbox-group stacked v-model='rouletteSelected' :options="roulettes">
        </b-form-checkbox-group>
      </b-form-group>

      <b-btn type='submit' class='my-2' variant='info'>Math me!</b-btn>
    </b-form>

    <section v-if='rouletteSuggestions'>
      <b-card v-for="key in Object.keys(rouletteSuggestions)" :key="key" :title="'Level ' + key">
        <b-card-text>
          <b-table :items="rouletteSuggestions[key]" />
        </b-card-text>
      </b-card>
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
        rouletteSuggestions: undefined,
      };
    },
    methods: {
      calculate(e) {
        if (typeof(e) !== 'undefined') e.preventDefault();
        axios({
          method: 'post',
          headers: { 'Content-Type': 'text/json' },
          url: '/metrics/roulette_calculator',
          data: {
            start_level: this.start_level,
            start_xp: this.start_xp,
            roulettes: this.rouletteSelected,
          }
        }).then((response) => {
          this.rouletteSuggestions = response.data;
        })
      },
    },
  };
</script>

<style scoped>

</style>
