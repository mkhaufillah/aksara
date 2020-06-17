<template>
  <v-container class="fill-height">
    <v-row justify="center" align="center">
      <v-col>
        <v-card id="login-card" max-width="400" class="mx-auto card-custom">
          <v-card-title>
            <h3 id="begin-activation" v-if="!isDone">{{ headText }}</h3>
            <h3 id="error-activation" v-if="isError && isDone">{{ headText }}</h3>
            <h3 id="success-activation" v-if="!isError && isDone">{{ headText }}</h3>
          </v-card-title>
          <v-card-text>
            {{ bodyText }}
          </v-card-text>
          <v-card-actions>
            <v-btn
              :disabled="isDone || isLoading"
              @click="activateAccount"
              color="secondary"
              class="btn-custom"
              block
              x-large
              :loading="isLoading"
            >Aktivasi akun</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios';

export default {
  name: 'accountActivation',
  data: () => ({
    isDone: false,
    headText: 'Halo...',
    bodyText: 'Silahkan aktivasi akun dengan klik tombol dibawah...',
    isError: false,
    token: '',
    email: '',
    isLoading: false,
  }),
  methods: {
    activateAccount() {
      this.isLoading = true;
      axios({
        method: 'post',
        url: `${this.$store.state.url}/auth/user/account-activation`,
        timeout: 3000,
        headers: {
          'Content-Type': 'application/json',
          Token: this.$store.state.token,
        },
        data: {
          email: this.email,
          token: this.token,
        },
      }).then((response) => {
        this.isDone = true;
        this.isError = false;
        this.headText = 'Sukses...';
        this.bodyText = response.data.msg;
        this.isLoading = false;
      }).catch((error) => {
        this.isDone = true;
        this.isError = true;
        this.headText = 'Gagal...';
        this.bodyText = error.response.data.err.msg;
        this.isLoading = false;
      });
    },
  },
  created() {
    if (this.$route.query.token && this.$route.query.email) {
      this.token = this.$route.query.token;
      this.email = this.$route.query.email;
    } else {
      this.$router.push('/tersesat');
    }
  },
};
</script>

<style lang="scss" scoped>
h3#begin-activation {
  color: #0a4472;
}

h3#success-activation {
  color: #1FAB89;
}

h3#error-activation {
  color: #E84545;
}

#login-card {
  padding: 12px;
}
</style>
