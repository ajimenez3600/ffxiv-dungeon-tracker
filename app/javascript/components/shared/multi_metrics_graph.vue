<template>
<Pivot
  :data="data"
  v-model="fields"
/>
</template>

<script>
import { Pivot } from 'vue-pivot-table-plus';

export default {
  components: {
    Pivot,
  },
  data() {
    return {
      data: Object.freeze([{ x:0,y:0,z:0 }, { x:1,y:1,z:1 }]),
      fields: {
        availableFields: [],
        rowFields: [
          {
            getter: item => item.x,
            label: 'X-Axis',
          },
          {
            getter: item => item.y,
            label: 'Y-Axis',
          }],
        colFields: [
          {
            getter: item => item.z,
            label: 'Z-Axis',
          },
        ],
        fieldsOrder: {},
      },
    };
  },
};
</script>

<style scoped>

</style>