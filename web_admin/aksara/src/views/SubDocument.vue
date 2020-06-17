<template>
  <v-container>
    <v-row>
      <v-col>
        <v-data-table
          :headers="headers"
          :items="subDocuments"
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
                <b>Sub Dokumen</b>
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
                label="Cari Sub Dokumen"
                single-line
                hide-details
              ></v-text-field>
              <v-divider
                class="mx-4"
                inset
                vertical
              ></v-divider>
              <v-spacer></v-spacer>
              <v-dialog v-model="dialog" max-width="500px">
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
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
                    <v-btn color="blue darken-1" text @click="save">Save</v-btn>
                  </v-card-actions>
                </v-card>
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
          <template v-slot:item.content="{ item }">
            <v-btn
              :to="`/contents?id=${item.id}`"
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
  name: 'subDocument',
  data: () => ({
    isLoading: false,
    documentId: 0,
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
      { text: 'Tgl Dibuat', value: 'createdAt' },
      { text: 'Tgl Diperbarui', value: 'updatedAt' },
      { text: 'Aksi', value: 'action', sortable: false },
      { text: 'Konten', value: 'content', sortable: false },
    ],
    subDocuments: [],
    editedIndex: -1,
    editedItem: {
      id: 0,
      title: '',
      createdAt: '',
      updatedAt: '',
    },
    defaultItem: {
      id: 0,
      title: '',
      createdAt: '',
      updatedAt: '',
    },
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
        url: `${this.$store.state.url}/get-sub-documents`,
        timeout: 3000,
        headers: {
          'Content-Type': 'application/json',
          Token: this.$store.state.token,
          Authorization: this.$cookies.get('user_session'),
        },
        params: {
          page: this.pageLoaded,
          documentId: this.documentId,
        },
      }).then((response) => {
        const subDocumentDatas = response.data.subDocuments;
        subDocumentDatas.forEach((e) => {
          const dateCreate = new Date(e.createdAt);
          const dateUpdate = new Date(e.updatedAt);
          e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
          e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          this.subDocuments.push(e);
        });
        if (subDocumentDatas.length <= 10 && subDocumentDatas.length > 0) {
          this.pageCount -= 1;
          this.endPage = true;
        }
        if (subDocumentDatas.length === 0) {
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
      this.subDocuments = [];
      this.loadData();
    },
    editItem(item) {
      this.editedIndex = this.subDocuments.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      // eslint-disable-next-line
      confirm('Are you sure you want to delete this item?') && (() => {
        this.isLoading = true;
        axios({
          method: 'post',
          url: `${this.$store.state.url}/admin/remove-sub-document`,
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
          url: `${this.$store.state.url}/admin/edit-sub-document`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          data: {
            id: this.editedItem.id,
            documentId: this.documentId,
            title: this.editedItem.title,
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
          url: `${this.$store.state.url}/admin/post-sub-document`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          data: {
            title: this.editedItem.title,
            documentId: this.documentId,
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
          url: `${this.$store.state.url}/search-sub-document`,
          timeout: 3000,
          headers: {
            'Content-Type': 'application/json',
            Token: this.$store.state.token,
            Authorization: this.$cookies.get('user_session'),
          },
          params: {
            documentId: this.documentId,
            page: 0,
            keyword: this.searchValue,
          },
        }).then((response) => {
          const subDocumentDatas = response.data.subDocuments;
          subDocumentDatas.forEach((e) => {
            const dateCreate = new Date(e.createdAt);
            const dateUpdate = new Date(e.updatedAt);
            e.createdAt = `${dateCreate.toDateString()} ${dateCreate.getHours().toString()}:${dateCreate.getMinutes().toString()}`;
            e.updatedAt = `${dateUpdate.toDateString()} ${dateUpdate.getHours().toString()}:${dateUpdate.getMinutes().toString()}`;
          });
          this.subDocuments = subDocumentDatas;
          this.isLoading = false;
        }).catch((error) => {
          this.$store.dispatch('snackShow', error.response.data.err.msg);
          this.isLoading = false;
        });
      }, 3000);
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
  },
  created() {
    if (!this.$cookies.get('user_session')) this.goingToLogin();
    if (this.$route.query.id) {
      this.documentId = this.$route.query.id;
      this.$store.commit('setNavItem', undefined);
      this.initialize();
    } else {
      this.$router.push('/documents');
    }
  },
};
</script>

<style lang="scss" scoped>
b {
  color: #0A4472;
}
</style>
