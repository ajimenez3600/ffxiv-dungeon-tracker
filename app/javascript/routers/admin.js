import { createRouter, createWebHistory } from 'vue-router';
import routes from '@/routes/admin';

const router = createRouter({
  history: createWebHistory('/admin/'),
  routes,
});

export default router;