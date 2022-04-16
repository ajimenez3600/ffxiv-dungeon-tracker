import { createApp } from 'vue';
import App from '@/apps/admin/MainLayout.vue';
import router from '@/routers/admin';
import '@/assets/css/admin.scss';

const app = createApp(App);

app.use(router);

console.log('admin')

app.mount('#app');