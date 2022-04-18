import { createApp } from 'vue';

import App from '@/apps/website/MainLayout.vue';
import router from '@/routers/website';
import { VuesticPlugin } from 'vuestic-ui';
import 'vuestic-ui/dist/vuestic-ui.css';

import '@/assets/css/style.scss';
import '@fortawesome/fontawesome-free/css/all.css'

// import Chart, { registerables } from 'chart.js/auto';
// import { Pivot } from 'vue-pivot-table-plus';

const app = createApp(App);

app.use(router);
app.use(VuesticPlugin, {
	colors: {
		primary: '#794bc4',
		info: '#794bc4',
	}
})

app.mount('#app');
