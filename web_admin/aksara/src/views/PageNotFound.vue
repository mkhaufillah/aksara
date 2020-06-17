<template>
  <div>
    <center>
      <h1><span>oh tidak,</span> kamu tersesat di alam lain..</h1>
      <v-btn color="secondary" class="btn-custom" @click="back">Kembali ke tempat yang benar</v-btn>
    </center>
  </div>
</template>

<script>
export default {
  name: 'pageNotFound',
  methods: {
    back() {
      this.$router.go(-1);
    },
  },
};
</script>

<style lang="scss" scoped>
h1 {
    margin: 24px;
    color: #0096FA;
    span {
      color: #0a4472;
    }
}
</style>
