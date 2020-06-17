import Vue from 'vue';
import Vuex from 'vuex';
import auth from './store_modules/auth';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    navigationShow: false,
    navItem: undefined,
    snackbar: false,
    textSnackbar: '',
    url: 'https://aksara.ub.ac.id/api',
    token: 'eyJhbGciOiJIUzI1NiJ9.ZjR5bk9HMjFNUQ.yYUXs4ili6YtlU4-XROeY4jbIkIWoxPnS4R5yEksYbk',
  },
  mutations: {
    setNavigationStatus(state, payload) {
      state.navigationShow = payload;
    },
    setNavItem(state, payload) {
      state.navItem = payload;
    },
    setSnackbarStatus(state, payload) {
      state.snackbar = payload;
    },
    setTextSnackbar(state, payload) {
      state.textSnackbar = payload;
    },
  },
  actions: {
    navHide(context) {
      setTimeout(() => {
        context.commit('setNavigationStatus', false);
      }, 10);
    },
    navShow(context) {
      setTimeout(() => {
        context.commit('setNavigationStatus', true);
      }, 10);
    },
    snackHide(context) {
      setTimeout(() => {
        context.commit('setSnackbarStatus', false);
      }, 10);
    },
    snackShow(context, msg) {
      setTimeout(() => {
        context.commit('setTextSnackbar', msg);
        context.commit('setSnackbarStatus', true);
      }, 10);
    },
  },
  modules: {
    auth,
  },
});
