<template>
<div>
	<TopNavbar />
	<div class='row justify--center' style="background-color:#999999;">
		<router-view  class='flex pt-2 xl-5 lg-8 md-10 sm-12' style="background-color:#ffffff;" />
	</div>
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

<style>
</style>
