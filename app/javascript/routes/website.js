const InstanceForm = () => import('@/views/website/InstanceForm.vue');
// const About = () => import('@/views/website/AboutPage.vue');
// const Login = () => import('@/views/website/LoginPage.vue');
// const Signup = () => import('@/views/website/SignupPage.vue');

const routes = [
  {
    path: '/',
    name: 'instance-form',
    components: {
      default: InstanceForm,
    },
  },
  // {
  //   path: '/about',
  //   name: 'about',
  //   components: {
  //     default: About,
  //   },
  // },
  // {
  //   path: '/login',
  //   name: 'login',
  //   components: {
  //     default: Login,
  //   },
  // },
  // {
  //   path: '/signup',
  //   name: 'signup',
  //   components: {
  //     default: Signup,
  //   },
  // },
];

export default routes;