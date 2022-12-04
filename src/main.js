import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import axios from "axios";
import vuetify from "./plugins/vuetify";
import VueCompositionAPI from "@vue/composition-api";
import Vuex from "vuex";
Vue.use(VueCompositionAPI);
Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    ip: "http://localhost:3000",
  },
  mutations: {
    initialiseStore(state) {
      // Check if the ID exists
      if (localStorage.getItem("store")) {
        // Replace the state object with the stored item
        this.replaceState(
          Object.assign(state, JSON.parse(localStorage.getItem("store")))
        );
      }
    },
    setIp(state, value) {
      state.ip = value;
      localStorage.setItem("store", JSON.stringify(state));
    },
  },
});
const http = axios.create();

Vue.prototype.$http = http;

Vue.config.productionTip = false;

Vue.prototype.$store = store;

new Vue({
  router,
  vuetify,
  render: (h) => h(App),
  beforeCreate() {
    this.$store.commit("initialiseStore");
  },
}).$mount("#app");
