import Vue from 'vue';
import Router from 'vue-router';
import NProgress from 'nprogress';
import './assets/nprogress.scss';

Vue.use(Router);

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('./views/Home.vue'),
    },
    {
      path: '/documents',
      name: 'document',
      component: () => import('./views/Document.vue'),
    },
    {
      path: '/sub-documents',
      name: 'subDocument',
      component: () => import('./views/SubDocument.vue'),
    },
    {
      path: '/contents',
      name: 'contentDoc',
      component: () => import('./views/Content.vue'),
    },
    {
      path: '/quizes',
      name: 'quiz',
      component: () => import('./views/Quiz.vue'),
    },
    {
      path: '/users',
      name: 'user',
      component: () => import('./views/User.vue'),
    },
    {
      path: '/admins',
      name: 'admin',
      component: () => import('./views/Admin.vue'),
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('./views/Login.vue'),
    },
    {
      path: '/reset-password',
      name: 'resetPassword',
      component: () => import('./views/ResetPassword.vue'),
    },
    {
      path: '/account-activation',
      name: 'accountActivation',
      component: () => import('./views/AccountActivation.vue'),
    },
    {
      path: '/show',
      name: 'show',
      component: () => import('./views/Show.vue'),
    },
    {
      path: '*',
      name: 'pageNotFound',
      component: () => import('./views/PageNotFound.vue'),
    },
  ],
});

NProgress.configure({
  easing: 'ease',
  speed: 500,
  showSpinner: false,
  parent: '#app',
});

router.beforeResolve((to, _from, next) => {
  if (to.name) {
    NProgress.start();
  }
  next();
});

router.afterEach(() => {
  NProgress.done();
});

export default router;
