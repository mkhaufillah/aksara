<template>
  <v-container>
    <v-row>
      <v-col>
        <v-data-table
          :headers="headers"
          :items="users"
          :page.sync="page"
          :items-per-page="itemsPerPage"
          hide-default-footer
          @page-count="pageCount = $event"
          :loading="isLoading"
          loading-text="Memuat data... silahkan menunggu"
        >
          <template v-slot:top>
            <v-toolbar flat color="white">
              <v-toolbar-title v-if="$vuetify.breakpoint.mdAndUp"><b>Pengguna</b></v-toolbar-title>
              <v-divider
                v-if="$vuetify.breakpoint.mdAndUp"
                class="mx-4"
                inset
                vertical
              ></v-divider>
              <v-text-field
                v-model="searchValue"
                append-icon="mdi-magnify"
                label="Cari Pengguna"
                single-line
                hide-details
              ></v-text-field>
              <v-divider
                class="mx-4"
                inset
                vertical
              ></v-divider>
            </v-toolbar>
          </template>
          <template v-slot:item.isActive="{ item }">
            <v-icon v-if="!item.isActive" small color="error">
              mdi-close-circle
            </v-icon>
            <v-icon v-if="item.isActive" small color="success">
              mdi-checkbox-marked-circle
            </v-icon>
          </template>
          <template v-slot:item.name="{ item }">
            <span v-if="item.name == null">
              Kosong
            </span>
            <span v-if="item.name != null">
              {{ item.name }}
            </span>
          </template>
          <template v-slot:item.faculty="{ item }">
            <span v-if="item.faculty == null">
              Kosong
            </span>
            <span v-if="item.faculty != null">
              {{ item.faculty }}
            </span>
          </template>
          <template v-slot:item.department="{ item }">
            <span v-if="item.department == null">
              Kosong
            </span>
            <span v-if="item.department != null">
              {{ item.department }}
            </span>
          </template>
          <template v-slot:item.studyProgram="{ item }">
            <span v-if="item.studyProgram == null">
              Kosong
            </span>
            <span v-if="item.studyProgram != null">
              {{ item.studyProgram }}
            </span>
          </template>
          <template v-slot:item.generation="{ item }">
            <span v-if="item.generation == null">
              Kosong
            </span>
            <span v-if="item.generation != null">
              {{ item.generation }}
            </span>
          </template>
        </v-data-table>
        <div class="text-center pt-2" v-if="searchValue === ''">
          <v-pagination v-model="page" :length="pageCount"></v-pagination>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios';

export default {
  name: 'user',
  data: () => ({
    isLoading: false,
    page: 1,
    pageCount: 0,
    itemsPerPage: 10,
    pageLoaded: 0,
    sectionLoaded: 0,
    endPage: false,
    searchValue: '',
    searchIsReady: true,
    headers: [
      { text: 'Email', value: 'email' },
      { text: 'Level', value: 'level' },
      { text: 'Nama', value: 'name' },
      { text: 'Fakultas', value: 'faculty' },
      { text: 'Jurusan', value: 'department' },
      { text: 'PS', value: 'studyProgram' },
      { text: 'Angkatan', value: 'generation' },
      { text: 'Aktif?', value: 'isActive' },
      { text: 'Tgl Dibuat', value: 'createdAt' },
      { text: 'Tgl Diperbarui', value: 'updatedAt' },
    ],
    users: [],
  }),
  methods: {
    goingToLogin() {
      this.$store.dispatch('navHide');
      this.$router.push('/login');
    },
    loadData() {
      this.isLoading = true;
      axios({
        method: 'get',
        url: `${this.$store.state.url}/admin/get-users`,
        timeout: 3000,
        headers: {
          'Content-Type': 'application/json',
          Token: this.$store.state.token,
          Authorization: this.$cookies.get('user_session'),
        },
        params: {
          page: this.pageLoaded,
        },
      }).then((response) => {
        const userDatas = response.data.users;
        userDatas.forEach((e) => {
          const dateCreate = new Date(e.createdAt);
          const dateUpdate = new Date(e.updatedAt);
          e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
          e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          this.users.push(e);
        });
        if (userDatas.length <= 10 && userDatas.length > 0) {
          this.pageCount -= 1;
          this.endPage = true;
        }
        if (userDatas.length === 0) {
          this.pageCount -= 2;
          this.endPage = true;
        }
        this.sectionLoaded += 1;
        this.isLoading = false;
      }).catch((error) => {
        this.$store.dispatch('snackShow', error.response.data.err.msg);
        this.isLoading = false;
      });
    },
    initialize() {
      this.page = 1;
      this.pageCount = 0;
      this.pageLoaded = 0;
      this.sectionLoaded = 0;
      this.endPage = false;
      this.users = [];
      this.loadData();
    },
    searchAction() {
      this.searchIsReady = false;
      this.isLoading = true;
      setTimeout(() => {
        this.searchIsReady = true;
        axios({
          method: 'get',
          url: `${this.$store.state.url}/admin/search-user`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          params: {
            page: 0,
            keyword: this.searchValue,
          },
        }).then((response) => {
          const userDatas = response.data.users;
          userDatas.forEach((e) => {
            const dateCreate = new Date(e.createdAt);
            const dateUpdate = new Date(e.updatedAt);
            e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
            e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          });
          this.users = userDatas;
          this.isLoading = false;
        }).catch((error) => {
          this.$store.dispatch('snackShow', error.response.data.err.msg);
          this.isLoading = false;
        });
      }, 3000);
    },
  },
  watch: {
    page(val) {
      if (this.page % 2 === 0) {
        this.pageLoaded = this.page / 2;
        if (this.sectionLoaded <= this.pageLoaded && !this.endPage) {
          this.loadData();
          this.pageCount += 2;
        }
      }
      return val;
    },
    searchValue(val) {
      if (val === '') this.initialize();
      if (this.searchIsReady) this.searchAction();
    },
  },
  created() {
    if (!this.$cookies.get('user_session')) this.goingToLogin();
    this.initialize();
  },
};
</script>

<style lang="scss" scoped>
b {
  color: #0A4472;
}
</style>
