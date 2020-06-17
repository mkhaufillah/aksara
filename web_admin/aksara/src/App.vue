<template>
  <v-app id="app">
    <v-app-bar
      id="app-bar-mobile"
      flat
      v-if="$vuetify.breakpoint.smAndDown && navStatus"
      color="light"
      dense
      fixed
      light
    >
      <v-app-bar-nav-icon @click.stop="drawer = true"></v-app-bar-nav-icon>
      <v-toolbar-title>Aksara</v-toolbar-title>
    </v-app-bar>
    <v-navigation-drawer
      app
      :permanent="$vuetify.breakpoint.mdAndUp"
      :temporary="$vuetify.breakpoint.smAndDown"
      v-model="drawer"
      v-if="navStatus"
    >
      <v-list>
        <v-list-item link @click="tolink('/')" color="secondary">
          <v-list-item-content>
            <v-list-item-title class="title"><strong>Aksara</strong></v-list-item-title>
            <v-list-item-subtitle v-if="admin">{{ admin.email }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </v-list>
      <v-divider></v-divider>
      <v-list nav dense>
        <v-list-item-group v-model="navItem">
          <v-list-item
            link
            v-for="item in items"
            :key="item.to"
            @click="tolink(item.to)"
            color="secondary"
          >
            <v-list-item-icon>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item link color="error" @click="logout">
            <v-list-item-icon>
              <v-icon>mdi-logout</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Logout</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
    <v-content>
      <p v-if="$vuetify.breakpoint.smAndDown"><br></p>
      <router-view></router-view>
    </v-content>
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}
      <v-btn color="accent" text @click="snackbarClose()">
        Tutup
      </v-btn>
    </v-snackbar>
  </v-app>
</template>

<script>
import './assets/style.scss';
import axios from 'axios';

export default {
  data() {
    return {
      drawer: null,
      items: [
        { title: 'Dokumen', icon: 'mdi-file-document-box-multiple', to: '/documents' },
        { title: 'Pengguna', icon: 'mdi-account-circle', to: '/users' },
        { title: 'Admin', icon: 'mdi-shield-check', to: '/admins' },
      ],
    };
  },
  computed: {
    navStatus() {
      return this.$store.state.navigationShow;
    },
    navItem: {
      get() {
        return this.$store.state.navItem;
      },
      set(v) {
        this.$store.commit('setNavItem', v);
      },
    },
    admin() {
      return this.$store.state.auth.admin;
    },
    snackbar: {
      get() {
        return this.$store.state.snackbar;
      },
      set(v) {
        this.$store.dispatch('snackShow', v);
      },
    },
    textSnackbar() {
      return this.$store.state.textSnackbar;
    },
  },
  methods: {
    tolink(link) {
      this.$router.push({ path: link }).catch(() => null);
    },
    initItem() {
      this.items.forEach((e, i) => {
        const currentUrl = window.location.pathname;
        if (e.to === currentUrl) this.$store.commit('setNavItem', i);
      });
    },
    navDecision() {
      const currentUrl = window.location.pathname;
      if (
        currentUrl === '/'
        || currentUrl === '/documents'
        || currentUrl === '/sub-documents'
        || currentUrl === '/contents'
        || currentUrl === '/quizes'
        || currentUrl === '/users'
        || currentUrl === '/admins'
      ) this.$store.dispatch('navShow');
      else this.$store.dispatch('navHide');
    },
    snackbarClose() {
      this.$store.dispatch('snackHide');
    },
    logout() {
      this.$cookies.remove('user_session');
      this.$store.dispatch('navHide');
      this.$router.push('/login');
    },
  },
  created() {
    this.initItem();
    this.navDecision();
    if (this.$cookies.get('user_session')) {
      axios({
        method: 'get',
        url: `${this.$store.state.url}/get-bio`,
        timeout: 3000,
        headers: {
          'Content-Type': 'application/json',
          Token: this.$store.state.token,
          Authorization: this.$cookies.get('user_session'),
        },
      }).then((response) => {
        this.$store.commit('auth/setAdmin', response.data.data);
      }).catch((error) => {
        this.$store.dispatch('snackShow', error.response.data.err.msg);
        this.logout();
      });
    }
  },
};
</script>

<style lang="scss" scoped>
#app {
  background-color: #FDFDFD;
}

strong {
  color: #0A4472;
}

#app-bar-mobile {
  -webkit-box-shadow: 0px 4px 0px 0px #0096FA !important;
  -moz-box-shadow: 0px 4px 0px 0px #0096FA !important;
  box-shadow: 0px 4px 0px 0px #0096FA !important;
}
</style>
