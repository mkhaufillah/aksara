import Vue from 'vue';
import Vuetify from 'vuetify/lib';

Vue.use(Vuetify);

export default new Vuetify({
  icons: {
    iconfont: 'mdi',
  },
  theme: {
    themes: {
      light: {
        primary: '#0A4472',
        light: '#FDFDFD',
        secondary: '#0096FA',
        accent: '#FCE38A',
        error: '#E84545',
        success: '#1FAB89',
      },
    },
  },
});
