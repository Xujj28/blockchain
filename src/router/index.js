import Vue from 'vue';
import Router from 'vue-router';
import Signup from '@/components/Signup';
import Home from '@/components/Home';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'signup',
      component: Signup
    },
    {
      path: '/home/:id/:administrator',
      name: 'home',
      component: Home
    }
  ]
});
