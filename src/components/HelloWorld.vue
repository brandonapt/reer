<template>
  <div>
    <v-row class="text-center">
      <v-col cols="12">
        <v-img
          :src="require('../assets/sunny.png')"
          class="my-3 mt-15"
          contain
          height="200"
        />
      </v-col>

      <v-col class="mb-4">
        <h1 class="display-2 font-weight-bold mb-3">welcome to reer</h1>
        <p @click="showipchanger = !showipchanger" v-ripple class="mb-n2 ipis">
          backend ip: {{ $store.state.ip }}
        </p>
      </v-col>
    </v-row>

    <v-expand-transition>
      <v-text-field
        v-model="newip"
        v-show="showipchanger"
        outlined
        dense
        class="ipchanger"
        label="new ip"
        append-icon="mdi-arrow-right-thick"
        @click:append="setIp"
      ></v-text-field>
    </v-expand-transition>

    <v-row class="mx-auto buttons">
      <v-btn
        v-bind:disabled="extended"
        v-bind:loading="loading1"
        @click="extend"
        color="blue"
        class="mr-2"
        >Extend</v-btn
      >
      <v-btn
        v-bind:disabled="!extended"
        v-bind:loading="loading2"
        @click="retract"
        color="orange"
        >Retract</v-btn
      >
    </v-row>
    <div class="cutpowerdiv">
      <v-btn
        class="cutpower"
        block
        @click="cut"
        v-bind:disabled="!loading1 && !loading2"
        color="red"
        >CUT POWER</v-btn
      >
    </div>
    <v-divider class="mt-7 mx-15"></v-divider>
    <v-slider
      dense
      class="secondslider"
      :hint="'Seconds (Currently ' + seconds + ')'"
      max="30"
      min="1"
      thumb-label="always"
      persistent-hint
      v-model="newSeconds"
    ></v-slider>
    <v-btn
      @click="setSeconds"
      color="green"
      v-bind:loading="loading3"
      class="setsecondsbutton"
      >Set Seconds</v-btn
    >
    <v-snackbar v-model="snackbar" :timeout="timeout" :color="color">
      {{ text }}
      <template v-slot:action="{ attrs }">
        <v-btn text v-bind="attrs" @click="snackbar = false"> Close </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  mounted: async function () {
    const response = await this.$http.get(this.$store.state.ip + "/extended");
    this.extended = response.data.extended;
    const res2 = await this.$http.get(this.$store.state.ip + "/seconds");
    this.seconds = res2.data.seconds;
    this.newSeconds = this.seconds;
  },
  methods: {
    async extend() {
      if (this.loading1 == true || this.loading2 == true) return;
      this.extended = true;
      this.text = "Extending...";
      this.color = "green";
      this.snackbar = true;
      this.loading1 = true;
      await this.$http.post(this.$store.state.ip + "/extend");
      this.text = "Extended!";
      this.color = "green";
      this.snackbar = true;
      this.loading1 = false;
    },
    async setSeconds() {
      this.text = "Setting seconds...";
      this.color = "green";
      this.snackbar = true;
      this.loading3 = true;
      await this.$http.post(
        this.$store.state.ip + "/setseconds/" + this.newSeconds
      );
      this.text = "Seconds set!";
      this.color = "green";
      this.snackbar = true;
      this.seconds = this.newSeconds;
      this.loading3 = false;
      this.seconds = this.newSeconds;
    },
    async cut() {
      this.text = "Cutting power...";
      this.color = "red";
      this.snackbar = true;
      await this.$http.post(this.$store.state.ip + "/cut");
      this.text = "Power cut!";
      this.color = "red";
      this.snackbar = true;
      this.loading2 = false;
      this.loading1 = false;
    },
    async setIp() {
      let res;
      try {
        res = await this.$http.get(this.newip + "/extended");
      } catch (e) {
        this.text = "Invalid IP!";
        this.color = "red";
        this.snackbar = true;
        return;
      }
      if (!res?.data?.success == true) {
        this.text = "IP set!";
        this.color = "green";
        this.snackbar = true;
        this.$store.commit("setIp", this.newip);
        this.showipchanger = false;
        return;
      } else {
        this.text = "invalid ip";
        this.color = "red";
        this.snackbar = true;
        return;
      }
    },
    async retract() {
      if (this.loading1 == true || this.loading2 == true) return;
      this.extended = false;
      this.text = "Retracting...";
      this.color = "green";
      this.snackbar = true;
      this.loading2 = true;
      await this.$http.post(this.$store.state.ip + "/retract");
      this.text = "Extended!";
      this.color = "green";
      this.snackbar = true;
      this.loading2 = false;
    },
  },
  data: () => ({
    extended: false,
    loading1: false,
    loading2: false,
    seconds: null,
    newSeconds: null,
    snackbar: false,
    loading3: false,
    showipchanger: false,
    text: "Extending...",
    newip: "",
    timeout: 3000,
    color: "success",
    ecosystem: [
      {
        text: "vuetify-loader",
        href: "https://github.com/vuetifyjs/vuetify-loader",
      },
      {
        text: "github",
        href: "https://github.com/vuetifyjs/vuetify",
      },
      {
        text: "awesome-vuetify",
        href: "https://github.com/vuetifyjs/awesome-vuetify",
      },
    ],
    importantLinks: [
      {
        text: "Documentation",
        href: "https://vuetifyjs.com",
      },
      {
        text: "Chat",
        href: "https://community.vuetifyjs.com",
      },
      {
        text: "Made with Vuetify",
        href: "https://madewithvuejs.com/vuetify",
      },
      {
        text: "Twitter",
        href: "https://twitter.com/vuetifyjs",
      },
      {
        text: "Articles",
        href: "https://medium.com/vuetify",
      },
    ],
    whatsNext: [
      {
        text: "Explore components",
        href: "https://vuetifyjs.com/components/api-explorer",
      },
      {
        text: "Select a layout",
        href: "https://vuetifyjs.com/getting-started/pre-made-layouts",
      },
      {
        text: "Frequently Asked Questions",
        href: "https://vuetifyjs.com/getting-started/frequently-asked-questions",
      },
    ],
  }),
};
</script>
<style scoped>
.buttons {
  display: flex;
  justify-content: center;
}

.secondslider {
  width: 50%;
  margin: auto;
  margin-top: 20px;
}

.setsecondsbutton {
  display: block;
  margin: auto;
}

.ipis {
  cursor: pointer;
  width: 200px;
  text-align: center;
  margin: 0 auto;
}

.ipchanger {
  display: block;
  margin: auto;
  margin-bottom: 10px;
  margin-top: 10px;
  width: 200px;
}

.cutpower {
  display: block;
  margin: 0 auto;
  margin-top: 30px;
  margin-bottom: 10px;
  width: 20px;
}

.cutpowerdiv {
  margin: 0 auto;
  width: 15%;
  text-align: center;
}
</style>
