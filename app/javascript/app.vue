<template>
  <div id="app">
    <b-button v-b-toggle.collapse-1 variant="primary">Toggle Collapse</b-button>
    <b-collapse id="collapse-1" class="mt-2">
      <b-card>
        <p class="card-text">Collapse contents Here</p>
      </b-card>
    </b-collapse>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
