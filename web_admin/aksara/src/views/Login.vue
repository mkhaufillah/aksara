<template>
  <v-container class="fill-height">
    <v-row justify="center" align="center">
      <v-col>
        <v-card id="login-card" max-width="400" class="mx-auto card-custom">
          <v-card-title>
            <h3>Login Aksara</h3>
          </v-card-title>
          <br>
          <v-card-text>
            <v-form ref="form" v-model="valid" lazy-validation>
              <v-text-field
                v-model="email"
                :rules="emailRules"
                label="Email kamu"
                required
                color="secondary"
                :disabled="isLoading"
              ></v-text-field>
              <v-text-field
                v-model="password"
                :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                :rules="[passwordRules.required]"
                :type="showPassword ? 'text' : 'password'"
                label="Password kamu"
                required
                @click:append="showPassword = !showPassword"
                color="secondary"
                :disabled="isLoading"
              ></v-text-field>
              <br />
              <v-alert v-if="alert !== ''" type="error">{{ alert }}</v-alert>
            </v-form>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              :disabled="!valid || isLoading"
              @click="login"
              color="secondary"
              class="btn-custom"
              :loading="isLoading"
            >Login</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios';

export default {
  name: 'login',
  data: () => ({
    valid: true,
    email: '',
    emailRules: [
      v => !!v || 'Email is required',
      v => /.+@.+/.test(v) || 'E-mail must be valid',
    ],
    showPassword: false,
    password: '',
    passwordRules: {
      required: value => !!value || 'Password required',
    },
    alert: '',
    isLoading: false,
  }),
  methods: {
    login() {
      if (this.$refs.form.validate()) {
        this.isLoading = true;
        axios({
          method: 'post',
          url: `${this.$store.state.url}/auth/admin/login`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
          },
          data: {
            email: this.email,
            password: this.password,
          },
        }).then((response) => {
          this.alert = '';
          this.$cookies.set('user_session', response.data.token, 60 * 60 * 24 * 7);
          this.$store.commit('auth/setAdmin', response.data.admin);
          this.isLoading = false;
          this.$store.dispatch('snackShow', response.data.msg);
          this.goingToHome();
        }).catch((error) => {
          this.alert = error.response.data.err.msg;
          this.isLoading = false;
        });
      }
    },
    goingToHome() {
      this.$store.dispatch('navShow');
      this.$router.push('/');
    },
  },
  created() {
    if (this.$cookies.get('user_session')) this.goingToHome();
  },
};
</script>

<style lang="scss" scoped>
h3 {
  color: #0a4472;
}

#login-card {
  padding: 12px;
}
</style>
