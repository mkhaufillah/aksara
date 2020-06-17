<template>
  <v-container class="fill-height">
    <v-row justify="center" align="center">
      <v-col>
        <v-card id="login-card" class="mx-auto card-custom">
          <v-card-title>
            <h3 class="head">{{ user.email }}</h3>
          </v-card-title>
          <v-card-title v-if="user.name != null">
            <h3 class="body">Nama: {{ user.name }}</h3>
          </v-card-title>
          <v-card-title v-if="user.level != null">
            <h3 class="body">Level: {{ user.level }}</h3>
          </v-card-title>
          <v-card-title v-if="achievement.point != null">
            <h3 class="body">Point: {{ achievement.point }}</h3>
          </v-card-title>
          <v-card-title v-if="achievement.rank != null">
            <h3 class="body">Rangking: {{ achievement.rank }}</h3>
          </v-card-title>
          <v-card-title v-if="user.faculty != null">
            <h3 class="body">Fakultas: {{ user.faculty }}</h3>
          </v-card-title>
          <v-card-title v-if="user.department != null">
            <h3 class="body">Jurusan {{ user.department }}</h3>
          </v-card-title>
          <v-card-title v-if="user.studyProgram != null">
            <h3 class="body">Prodi {{ user.studyProgram }}</h3>
          </v-card-title>
          <v-card-title v-if="user.generation != null">
            <h3 class="body">Angkatan {{ user.generation }}</h3>
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios';

export default {
  name: 'show',
  data: () => ({
    user: '',
    achievement: '',
    isLoading: false,
  }),
  created() {
    if (this.$route.query.email) {
      axios({
        method: 'get',
        url: `${this.$store.state.url}/show`,
        timeout: 3000,
        headers: {
          'Content-Type': 'application/json',
          Token: this.$store.state.token,
        },
        params: {
          email: this.$route.query.email,
        },
      }).then((response) => {
        const userData = response.data.user;
        const achievementData = response.data.achievement;
        this.user = userData;
        this.achievement = achievementData;
        this.isLoading = false;
      }).catch((error) => {
        this.$store.dispatch(
          'snackShow',
          error.response.data.err.msg,
        );
        this.isLoading = false;
      });
    } else {
      this.$router.push('/tersesat');
    }
  },
};
</script>

<style lang="scss" scoped>
h3.head {
  color: #0a4472;
}

h3.body {
  color: #0096FA;
}

#login-card {
  padding: 12px;
}
</style>
