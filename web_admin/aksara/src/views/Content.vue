<template>
  <v-container>
    <v-row>
      <v-col>
        <v-data-table
          :headers="headers"
          :items="contents"
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
                <b>Konten</b>
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
                label="Cari Konten"
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
                    <v-textarea
                      v-model="editedItem.content"
                      label="Konten"
                      auto-grow
                    ></v-textarea>
                    <v-textarea
                      v-model="editedItem.santun"
                      label="Contoh Santun"
                      auto-grow
                    ></v-textarea>
                    <v-textarea
                      v-model="editedItem.akrab"
                      label="Contoh Akrab"
                      auto-grow
                    ></v-textarea>
                    <v-textarea
                      v-model="editedItem.copy"
                      label="Template Salin"
                      auto-grow
                    ></v-textarea>
                    <v-text-field
                      v-model="editedItem.link"
                      label="Link"
                      auto-grow
                    ></v-text-field>
                    <v-card v-if="(editedIndex <= -1)">
                      <v-card-text>
                        <v-data-table
                          :headers="[
                            { text: 'Konten', value: 'content' },
                            { text: 'Aksi', value: 'actionDialog', sortable: false },
                          ]"
                          :items="editedItem.dialogs"
                        >
                          <template v-slot:item.actionDialog="{ item }">
                            <v-icon
                              small
                              @click="deleteItemDialog(item)"
                            >
                              mdi-delete
                            </v-icon>
                          </template>
                        </v-data-table>
                        <br>
                        <v-text-field
                          v-model="tempDialog"
                          label="Tambah konten dialog"
                        ></v-text-field>
                        <v-btn
                          color="secondary"
                          class="btn-custom"
                          @click="addDialog"
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
              <v-dialog v-model="dialogItemDialog" max-width="700px">
                <v-data-table
                  :headers="headersDialog"
                  :items="editedItem.dialogs"
                ></v-data-table>
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
          <template v-slot:item.dialog="{ item }">
            <v-btn
              @click="showDialog(item)"
              x-small
              class="btn-custom"
              color="secondary"
            >Lihat</v-btn>
          </template>
          <template v-slot:item.quiz="{ item }">
            <v-btn
              :to="`/quizes?id=${item.id}`"
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
  name: 'contentDoc',
  data: () => ({
    isLoading: false,
    subDocumentId: 0,
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
      { text: 'Konten', value: 'content' },
      { text: 'Santun', value: 'santun' },
      { text: 'Akrab', value: 'akrab' },
      { text: 'Copy', value: 'copy' },
      { text: 'Link', value: 'link' },
      { text: 'Tgl Dibuat', value: 'createdAt' },
      { text: 'Tgl Diperbarui', value: 'updatedAt' },
      { text: 'Aksi', value: 'action', sortable: false },
      { text: 'Dialog', value: 'dialog', sortable: false },
      { text: 'Kuis', value: 'quiz', sortable: false },
    ],
    contents: [],
    editedIndex: -1,
    editedItem: {
      id: 0,
      title: '',
      content: '',
      santun: '',
      akrab: '',
      copy: '',
      link: '',
      dialogs: [],
      createdAt: '',
      updatedAt: '',
    },
    defaultItem: {
      id: 0,
      title: '',
      content: '',
      santun: '',
      akrab: '',
      copy: '',
      link: '',
      dialogs: [],
      createdAt: '',
      updatedAt: '',
    },
    tempDialog: '',
    dialogItemDialog: false,
    headersDialog: [
      { text: 'Konten', value: 'content' },
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
        url: `${this.$store.state.url}/get-contents`,
        timeout: 3000,
        headers: {
          'Content-Type': 'application/json',
          Token: this.$store.state.token,
          Authorization: this.$cookies.get('user_session'),
        },
        params: {
          page: this.pageLoaded,
          subDocumentId: this.subDocumentId,
        },
      }).then((response) => {
        const contentDatas = response.data.contents;
        contentDatas.forEach((e) => {
          const dateCreate = new Date(e.createdAt);
          const dateUpdate = new Date(e.updatedAt);
          e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
          e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          e.dialogs.forEach((el, i) => {
            const dateCreateD = new Date(el.createdAt);
            const dateUpdateD = new Date(el.updatedAt);
            e.dialogs[i].createdAt = `${dateCreateD.toDateString()} ${dateCreateD.getHours().toString()}:${dateCreateD.getMinutes().toString()}`;
            e.dialogs[i].updatedAt = `${dateUpdateD.toDateString()} ${dateUpdateD.getHours().toString()}:${dateUpdateD.getMinutes().toString()}`;
          });
          this.contents.push(e);
        });
        if (contentDatas.length <= 10 && contentDatas.length > 0) {
          this.pageCount -= 1;
          this.endPage = true;
        }
        if (contentDatas.length === 0) {
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
      this.contents = [];
      this.loadData();
    },
    editItem(item) {
      this.editedIndex = this.contents.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      // eslint-disable-next-line
      confirm('Are you sure you want to delete this item?') && (() => {
        this.isLoading = true;
        axios({
          method: 'post',
          url: `${this.$store.state.url}/admin/remove-content`,
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
          url: `${this.$store.state.url}/admin/edit-content`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          data: {
            id: this.editedItem.id,
            subDocumentId: this.subDocumentId,
            title: this.editedItem.title,
            content: this.editedItem.content,
            santun: this.editedItem.santun,
            akrab: this.editedItem.akrab,
            copy: this.editedItem.copy,
            link: this.editedItem.link,
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
          url: `${this.$store.state.url}/admin/post-content`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          data: {
            title: this.editedItem.title,
            content: this.editedItem.content,
            subDocumentId: this.subDocumentId,
            dialogs: this.editedItem.dialogs,
            santun: this.editedItem.santun,
            akrab: this.editedItem.akrab,
            copy: this.editedItem.copy,
            link: this.editedItem.link,
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
          url: `${this.$store.state.url}/search-content`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          params: {
            subDocumentId: this.subDocumentId,
            page: 0,
            keyword: this.searchValue,
          },
        }).then((response) => {
          const contentDatas = response.data.contents;
          contentDatas.forEach((e) => {
            const dateCreate = new Date(e.createdAt);
            const dateUpdate = new Date(e.updatedAt);
            e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
            e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          });
          this.contents = contentDatas;
          this.isLoading = false;
        }).catch((error) => {
          this.$store.dispatch('snackShow', error.response.data.err.msg);
          this.isLoading = false;
        });
      }, 3000);
    },
    showDialog(item) {
      this.editedIndex = this.contents.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialogItemDialog = true;
    },
    closeDialog() {
      this.dialogItemDialog = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    addDialog() {
      this.editedItem.dialogs.push({ content: this.tempDialog });
    },
    deleteItemDialog(item) {
      const index = this.editedItem.dialogs.indexOf(item);
      this.editedItem.dialogs.splice(index, 1);
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
    dialogItemDialog(val) {
      return val || this.closeDialog();
    },
  },
  created() {
    if (!this.$cookies.get('user_session')) this.goingToLogin();
    if (this.$route.query.id) {
      this.subDocumentId = this.$route.query.id;
      this.$store.commit('setNavItem', undefined);
      this.initialize();
    } else {
      this.$router.push('/sub-documents');
    }
  },
};
</script>

<style lang="scss" scoped>
b {
  color: #0A4472;
}
</style>
