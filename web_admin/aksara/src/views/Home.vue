<template>
  <v-container class="fill-height">
    <v-row justify="center" align="center">
      <v-col class="shrink">
        <img :src="require('@/assets/splash.png')" alt="" id="img">
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: 'home',
  methods: {
    goingToLogin() {
      this.$store.dispatch('navHide');
      this.$router.push('/login');
    },
  },
  created() {
    if (!this.$cookies.get('user_session')) this.goingToLogin();
    this.$store.commit('setNavItem', undefined);
  },
};
</script>

<style lang="scss" scoped>
#img {
  height: 60vh;
}
</style>
