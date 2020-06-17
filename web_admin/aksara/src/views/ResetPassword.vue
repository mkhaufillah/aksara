<template>
  <v-container class="fill-height">
    <v-row justify="center" align="center">
      <v-col>
        <v-card v-if="isDone" id="login-card" max-width="400" class="mx-auto card-custom">
          <v-card-title>
            <h3>Sukses</h3>
          </v-card-title>
          <v-card-text>
            Silahkan login ke aplikasi menggunakan password baru
          </v-card-text>
        </v-card>
        <v-card v-if="!isDone" id="login-card" max-width="400" class="mx-auto card-custom">
          <v-card-title>
            <h3>Reset Password</h3>
          </v-card-title>
          <br>
          <v-card-text>
            <v-form ref="form" v-model="valid" lazy-validation>
              <v-text-field
                v-model="password"
                :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                :rules="[passwordRules.required]"
                :type="showPassword ? 'text' : 'password'"
                label="Tulis password baru"
                required
                @click:append="showPassword = !showPassword"
                color="secondary"
                :disabled="isLoading"
              ></v-text-field>
              <v-text-field
                v-model="password2"
                :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                :rules="[passwordRules.required]"
                :type="showPassword ? 'text' : 'password'"
                label="Ulangi password baru"
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
              @click="resetPassword"
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
  name: 'resetPassword',
  data: () => ({
    isDone: false,
    valid: true,
    showPassword: false,
    password: '',
    password2: '',
    passwordRules: {
      required: value => !!value || 'Password required',
    },
    alert: '',
    token: '',
    email: '',
    isLoading: false,
  }),
  methods: {
    resetPassword() {
      if (this.$refs.form.validate()) {
        if (this.password !== this.password2) {
          this.alert = 'Password tidak sama';
          return;
        }
        this.isLoading = true;
        axios({
          method: 'post',
          url: `${this.$store.state.url}/auth/user/action-reset-password`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
          },
          data: {
            email: this.email,
            token: this.token,
            password: this.password,
          },
        }).then((response) => {
          this.isDone = true;
          this.isLoading = false;
          this.$store.dispatch('snackShow', response.data.msg);
        }).catch((error) => {
          this.alert = error.response.data.err.msg;
          this.isLoading = false;
        });
      }
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
h3 {
  color: #0a4472;
}

#login-card {
  padding: 12px;
}
</style>
