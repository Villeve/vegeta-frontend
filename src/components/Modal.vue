<template>
  <div class="container">
      <section>
        <b-field label="Title">
          <b-input v-model="title" maxlength="40"></b-input>
        </b-field>
        <b-field label="Technologies">
          <b-input v-model="technologies" maxlength="40"></b-input>
        </b-field>
        <b-field label="Description">
          <b-input v-model="description" maxlength="200" type="textarea"></b-input>
        </b-field>
        <b-field label="Budget (€)">
          <b-numberinput v-model="budget"></b-numberinput>
        </b-field>
        <b-field label="Contact Email">
          <b-input v-model="contactEmail" maxlength="60"></b-input>
        </b-field>
        <b-button v-if="editing" type="is-primary" @click="updateGig" expanded>
          Click to Update
        </b-button>
        <b-button v-else type="is-primary" @click="createGig" expanded>
          Click to Create
        </b-button>
         <p v-if="errors.length">
          <b>Please correct the following error(s):</b>
          <ul>
            <li class="has-text-danger" v-for="(error, index) in errors" :key="index">{{ error }}</li>
          </ul>
        </p>
      </section>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Modal",
  props: {
    selected: {
      type: Object,
      default: null
    },
    editing: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    async createGig() {
      try {
        if(!this.checkForm()) {
          return;
        }
        const gigObject = {
          title: this.title,
          technologies: this.technologies,
          description: this.description,
          budget: this.budget,
          contactEmail: this.contactEmail
        }
        const response = await axios.post('http://localhost/api/gigs/add', null, {
          params: gigObject          
        });
        this.$emit('close')
      } catch (e) {
        console.log(e);
      }
    },
    async updateGig() {
      try {
        if(!this.checkForm()) {
          return;
        }
        const gigObject = {
          title: this.title,
          technologies: this.technologies,
          description: this.description,
          budget: this.budget,
          contactEmail: this.contactEmail
        }
        const response = await axios.put(`http://localhost/api/gigs/update/${this.selected.id}`, null, {
          params: gigObject          
        });
        this.$emit('close')
      } catch (e) {
        console.log(e);
      }
    },
    checkForm() {
      this.errors = [];

      if(!this.title) {
        this.errors.push("Title required!")
      }
      if(!this.technologies) {
        this.errors.push("Technologies required!")
      }
      if(!this.description) {
        this.errors.push("Description required!")
      }
      if(this.budget < 0) {
        this.errors.push("Budget required and it must not be negative!")
      }
      if(!this.contactEmail) {
        this.errors.push("Email required!")
      }
      else if(!this.validEmail(this.contactEmail)) {
        this.errors.push("Valid email required!")
      }

      if(!this.errors.length) {
        return true
      }
    },
    validEmail(email) {
      const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
    }
  },
  data: function() {
    return {
      errors: [],
      title: "",
      technologies: "",
      description: "",
      budget: 0,
      contactEmail: ""
    };
  },
  mounted() {
    if(this.editing) {
      this.title = this.selected.title
      this.technologies = this.selected.technologies
      this.description = this.selected.description
      this.budget = Number(this.selected.budget)
      this.contactEmail = this.selected.contactEmail
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.container {
  background-color: whitesmoke;
  padding: 1em;
}
</style>
