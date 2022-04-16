<template>
<div>
	<TopNavbar />
	<router-view />
</div>
</template>

<script>
import TopNavbar from '@/views/website/TopNavbar.vue';

export default {
  data() {
    return {
    }
  },
	components: {
		TopNavbar,
	},
}
</script>
