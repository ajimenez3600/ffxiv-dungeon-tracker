const Index = () => import('@/views/admin/IndexPage.vue');

const routes = [
  {
    path: '/',
    name: 'index',
    components: {
      default: Index,
    },
  },
];

export default routes;