<template>
  <v-container>
    <v-row>
      <v-col>
        <v-data-table
          :headers="headers"
          :items="quizes"
          :page.sync="page"
          :items-per-page="itemsPerPage"
          hide-default-footer
          @page-count="pageCount = $event"
          :loading="isLoading"
          loading-text="Memuat data... silahkan menunggu"
        >
          <template v-slot:top>
            <v-toolbar flat color="white">
              <v-toolbar-title v-if="$vuetify.breakpoint.mdAndUp">
                <b>Kuis</b>
              </v-toolbar-title>
              <v-divider
                v-if="$vuetify.breakpoint.mdAndUp"
                class="mx-4"
                inset
                vertical
              ></v-divider>
              <v-text-field
                v-model="searchValue"
                append-icon="mdi-magnify"
                label="Cari Kuis"
                single-line
                hide-details
              ></v-text-field>
              <v-divider
                class="mx-4"
                inset
                vertical
              ></v-divider>
              <v-spacer></v-spacer>
              <v-dialog v-model="dialog" max-width="700px">
                <template v-slot:activator="{ on }">
                  <v-btn color="secondary" dark class="mb-2 btn-custom" v-on="on">Item Baru</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ formTitle }}</span>
                  </v-card-title>
                  <v-card-text>
                    <v-text-field
                      v-model="editedItem.title"
                      label="Judul"
                    ></v-text-field>
                    <v-text-field
                      v-model="editedItem.question"
                      label="Pertanyaan"
                    ></v-text-field>
                    <v-card v-if="(editedIndex <= -1)">
                      <v-card-text>
                        <v-data-table
                          color="accent"
                          :headers="[
                            { text: 'Judul', value: 'title' },
                            { text: 'Jawaban', value: 'answer' },
                            { text: 'Warna', value: 'color' },
                            { text: 'Warna Teks', value: 'textColor' },
                            { text: 'Benar?', value: 'isCorrect' },
                            { text: 'Aksi', value: 'actionAnswer', sortable: false },
                          ]"
                          :items="editedItem.answers"
                        >
                          <template v-slot:item.isCorrect="{ item }">
                            <v-icon v-if="!item.isCorrect" small color="error">
                              mdi-close-circle
                            </v-icon>
                            <v-icon v-if="item.isCorrect" small color="success">
                              mdi-checkbox-marked-circle
                            </v-icon>
                          </template>
                          <template v-slot:item.color="{ item }">
                            <v-icon small :color="item.color">
                              mdi-format-color-fill
                            </v-icon>
                          </template>
                          <template v-slot:item.textColor="{ item }">
                            <v-icon small :color="item.textColor">
                              mdi-format-color-fill
                            </v-icon>
                          </template>
                          <template v-slot:item.actionAnswer="{ item }">
                            <v-icon
                              small
                              @click="deleteItemAnswer(item)"
                            >
                              mdi-delete
                            </v-icon>
                          </template>
                        </v-data-table>
                        <br>
                        <v-text-field
                          v-model="tempTitle"
                          label="Judul"
                        ></v-text-field>
                        <v-text-field
                          v-model="tempAnswer"
                          label="Jawaban"
                        ></v-text-field>
                        <v-row>
                          <v-col cols="12" sm="6">
                            <v-color-picker v-model="tempColor"></v-color-picker>
                            <br>
                            <v-text-field
                              v-model="tempColor"
                              label="Warna"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="12" sm="6">
                            <v-color-picker v-model="tempTextColor"></v-color-picker>
                            <br>
                            <v-text-field
                              v-model="tempTextColor"
                              label="Warna Teks"
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-select
                          :items="[true, false]"
                          label="Benar?"
                          v-model="tempIsCorrect"
                        ></v-select>
                        <v-alert v-if="alert !== ''" type="error">{{ alert }}</v-alert>
                        <v-btn
                          color="secondary"
                          class="btn-custom"
                          @click="addAnswer"
                        >Tambah</v-btn>
                      </v-card-text>
                    </v-card>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
                    <v-btn color="blue darken-1" text @click="save">Save</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
              <v-dialog v-model="dialogItemAnswer" max-width="700px">
                <v-data-table
                  :headers="headersAnswer"
                  :items="editedItem.answers"
                >
                  <template v-slot:item.isCorrect="{ item }">
                    <v-icon v-if="!item.isCorrect" small color="error">
                      mdi-close-circle
                    </v-icon>
                    <v-icon v-if="item.isCorrect" small color="success">
                      mdi-checkbox-marked-circle
                    </v-icon>
                  </template>
                  <template v-slot:item.color="{ item }">
                    <v-icon small :color="item.color">
                      mdi-format-color-fill
                    </v-icon>
                  </template>
                  <template v-slot:item.textColor="{ item }">
                    <v-icon small :color="item.textColor">
                      mdi-format-color-fill
                    </v-icon>
                  </template>
                </v-data-table>
              </v-dialog>
            </v-toolbar>
          </template>
          <template v-slot:item.action="{ item }">
            <v-icon
              small
              class="mr-2"
              @click="editItem(item)"
            >
              mdi-pencil
            </v-icon>
            <v-icon
              small
              @click="deleteItem(item)"
            >
              mdi-delete
            </v-icon>
          </template>
          <template v-slot:item.answer="{ item }">
            <v-btn
              @click="showAnswer(item)"
              x-small
              class="btn-custom"
              color="secondary"
            >Lihat</v-btn>
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
  name: 'quiz',
  data: () => ({
    alert: '',
    isLoading: false,
    contentId: 0,
    page: 1,
    pageCount: 0,
    itemsPerPage: 10,
    pageLoaded: 0,
    sectionLoaded: 0,
    endPage: false,
    searchValue: '',
    searchIsReady: true,
    dialog: false,
    headers: [
      { text: 'Judul', value: 'title' },
      { text: 'Pertanyaan', value: 'question' },
      { text: 'Tgl Dibuat', value: 'createdAt' },
      { text: 'Tgl Diperbarui', value: 'updatedAt' },
      { text: 'Aksi', value: 'action', sortable: false },
      { text: 'Jawaban', value: 'answer', sortable: false },
    ],
    quizes: [],
    editedIndex: -1,
    editedItem: {
      id: 0,
      title: '',
      question: '',
      answers: [],
      createdAt: '',
      updatedAt: '',
    },
    defaultItem: {
      id: 0,
      title: '',
      question: '',
      answers: [],
      createdAt: '',
      updatedAt: '',
    },
    tempTitle: '',
    tempColor: '',
    tempTextColor: '',
    tempAnswer: '',
    tempIsCorrect: false,
    dialogItemAnswer: false,
    headersAnswer: [
      { text: 'Judul', value: 'title' },
      { text: 'Jawaban', value: 'answer' },
      { text: 'Warna', value: 'color' },
      { text: 'Warna Teks', value: 'textColor' },
      { text: 'Benar?', value: 'isCorrect' },
      { text: 'Tgl Dibuat', value: 'createdAt' },
      { text: 'Tgl Diperbarui', value: 'updatedAt' },
    ],
  }),
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? 'Item Baru' : 'Edit Item';
    },
  },
  methods: {
    goingToLogin() {
      this.$store.dispatch('navHide');
      this.$router.push('/login');
    },
    loadData() {
      this.isLoading = true;
      axios({
        method: 'get',
        url: `${this.$store.state.url}/admin/get-quizes`,
        timeout: 3000,
        headers: {
          'Content-Type': 'application/json',
          Token: this.$store.state.token,
          Authorization: this.$cookies.get('user_session'),
        },
        params: {
          page: this.pageLoaded,
          contentId: this.contentId,
        },
      }).then((response) => {
        const quizDatas = response.data.quizes;
        quizDatas.forEach((e) => {
          const dateCreate = new Date(e.createdAt);
          const dateUpdate = new Date(e.updatedAt);
          e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
          e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          e.answers.forEach((el, i) => {
            const dateCreateD = new Date(el.createdAt);
            const dateUpdateD = new Date(el.updatedAt);
            e.answers[i].createdAt = `${dateCreateD.toDateString()} ${dateCreateD.getHours().toString()}:${dateCreateD.getMinutes().toString()}`;
            e.answers[i].updatedAt = `${dateUpdateD.toDateString()} ${dateUpdateD.getHours().toString()}:${dateUpdateD.getMinutes().toString()}`;
          });
          this.quizes.push(e);
        });
        if (quizDatas.length <= 10 && quizDatas.length > 0) {
          this.pageCount -= 1;
          this.endPage = true;
        }
        if (quizDatas.length === 0) {
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
      this.quizes = [];
      this.loadData();
    },
    editItem(item) {
      this.editedIndex = this.quizes.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      // eslint-disable-next-line
      confirm('Are you sure you want to delete this item?') && (() => {
        this.isLoading = true;
        axios({
          method: 'post',
          url: `${this.$store.state.url}/admin/remove-quiz`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          data: {
            id: item.id,
          },
        }).then((response) => {
          this.initialize();
          this.$store.dispatch('snackShow', response.data.msg);
          this.isLoading = false;
        }).catch((error) => {
          this.$store.dispatch('snackShow', error.response.data.err.msg);
          this.isLoading = false;
        });
      })();
    },
    close() {
      this.dialog = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    save() {
      this.isLoading = true;
      if (this.editedIndex > -1) {
        axios({
          method: 'post',
          url: `${this.$store.state.url}/admin/edit-quiz`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          data: {
            id: this.editedItem.id,
            contentId: this.contentId,
            title: this.editedItem.title,
            question: this.editedItem.question,
          },
        }).then((response) => {
          this.initialize();
          this.$store.dispatch('snackShow', response.data.msg);
          this.isLoading = false;
        }).catch((error) => {
          this.$store.dispatch('snackShow', error.response.data.err.msg);
          this.isLoading = false;
        });
      } else {
        axios({
          method: 'post',
          url: `${this.$store.state.url}/admin/post-quiz`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          data: {
            title: this.editedItem.title,
            question: this.editedItem.question,
            contentId: this.contentId,
            answers: this.editedItem.answers,
          },
        }).then((response) => {
          this.initialize();
          this.$store.dispatch('snackShow', response.data.msg);
          this.isLoading = false;
        }).catch((error) => {
          this.$store.dispatch('snackShow', error.response.data.err.msg);
          this.isLoading = false;
        });
      }
      this.close();
    },
    searchAction() {
      this.searchIsReady = false;
      this.isLoading = true;
      setTimeout(() => {
        this.searchIsReady = true;
        axios({
          method: 'get',
          url: `${this.$store.state.url}/admin/search-quiz`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          params: {
            contentId: this.contentId,
            page: 0,
            keyword: this.searchValue,
          },
        }).then((response) => {
          const quizDatas = response.data.quizes;
          quizDatas.forEach((e) => {
            const dateCreate = new Date(e.createdAt);
            const dateUpdate = new Date(e.updatedAt);
            e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
            e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          });
          this.quizes = quizDatas;
          this.isLoading = false;
        }).catch((error) => {
          this.$store.dispatch('snackShow', error.response.data.err.msg);
          this.isLoading = false;
        });
      }, 3000);
    },
    showAnswer(item) {
      this.editedIndex = this.quizes.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialogItemAnswer = true;
    },
    closeAnswer() {
      this.dialogItemAnswer = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    addAnswer() {
      if (
        this.tempTitle === ''
        || this.tempAnswer === ''
        || this.tempColor === ''
        || this.tempTextColor === ''
      ) {
        this.alert = 'Lengkapi terlebih dahulu form yang disediakan';
        return;
      }
      if (this.editedItem.answers.length === 4) {
        this.alert = 'Jawaban sudah empat';
        return;
      }
      this.alert = '';
      this.editedItem.answers.push({
        title: this.tempTitle,
        answer: this.tempAnswer,
        color: this.tempColor,
        textColor: this.tempTextColor,
        isCorrect: this.tempIsCorrect,
      });
      if (this.editedItem.answers.length === 4) {
        let check = 0;
        this.editedItem.answers.forEach((e) => {
          if (e.isCorrect) check += 1;
        });
        if (check !== 1) {
          this.alert = 'Jawaban benar harus ada satu';
        } else {
          this.alert = '';
        }
      }
    },
    deleteItemAnswer(item) {
      const index = this.editedItem.answers.indexOf(item);
      this.editedItem.answers.splice(index, 1);
    },
  },
  watch: {
    dialog(val) {
      return val || this.close();
    },
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
    dialogItemAnswer(val) {
      return val || this.closeAnswer();
    },
  },
  created() {
    if (!this.$cookies.get('user_session')) this.goingToLogin();
    if (this.$route.query.id) {
      this.contentId = this.$route.query.id;
      this.$store.commit('setNavItem', undefined);
      this.initialize();
    } else {
      this.$router.push('/content');
    }
  },
};
</script>

<style lang="scss" scoped>
b {
  color: #0A4472;
}
</style>
