export default {
  namespaced: true,
  state: {
    admin: {},
  },
  mutations: {
    setAdmin(state, admin) {
      state.admin = admin;
    },
  },
  actions: {},
};
