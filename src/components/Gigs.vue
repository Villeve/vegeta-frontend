<template>
  <div class="gigs">
      <div class="columns is-gapless">
      <b-button class="column" type="is-success" @click="openCreateGigModal">New Gig</b-button>
      <b-button class="column" type="is-warning" @click="openUpdateGigModal" :disabled="!selected">Edit Selected</b-button>
      <b-button
      class="column"
        type="is-danger"
        @click="removeGig(selected.id)"
        :disabled="!selected"
        icon-left="delete"
      >Delete</b-button>
      <b-button class="column" type="is-warning" @click="selected = null" :disabled="!selected" outlined icon-left="close">
        Clear selected
      </b-button>
      </div>
      <b-modal :active.sync="isModalActive">
        <Modal :editing="editing" :selected="selected" @close="closeModal" />
      </b-modal>
      <b-table :data="gigs" :selected.sync="selected" detailed detail-key="description">
        <template slot-scope="props">
          <b-table-column field="title" label="Title">{{props.row.title}}</b-table-column>
          <b-table-column field="technologies" label="Technologies">{{props.row.technologies}}</b-table-column>
          <b-table-column field="budget" label="Budget">{{props.row.budget}}</b-table-column>
          <b-table-column field="contactEmail" label="Contact">{{props.row.contactEmail}}</b-table-column>
          <b-table-column field="createdAt" label="Date">{{props.row.createdAt}}</b-table-column>
        </template>
        <template slot="detail" slot-scope="props">
                <article class="media">
                    <div class="media-content">
                        <div class="content">
                            <p>
                                <strong>Description</strong>
                                <br>
                                {{ props.row.description }}
                            </p>
                        </div>
                    </div>
                </article>
            </template>
      </b-table>
  </div>
</template>

<script>
import axios from "axios";
import Modal from "./Modal.vue";

export default {
  name: "Gigs",
  components: {
    Modal
  },
  data: function() {
    return {
      gigs: [],
      selected: null,
      isModalActive: false,
      editing: false
    };
  },
  methods: {
    async fetchGigs() {
      try {
        const response = await axios.get(`http://localhost/api/gigs`);
        this.gigs = Object.values(response.data);
        this.selected = null;
      } catch (e) {
        console.log(e);
      }
    },
    async removeGig(id) {
      try {
        await axios.delete(`http://localhost/api/gigs/remove/${id}`);
        const index = this.gigs.findIndex(gig => gig.id === id);
        this.gigs.splice(index, 1);
      } catch (e) {
        console.log(e);
      }
    },
    openUpdateGigModal() {
      this.editing = true;
      this.isModalActive = true;
    },
    openCreateGigModal() {
      this.editing = false;
      this.isModalActive = true;
    },
    closeModal() {
      this.fetchGigs();
      this.isModalActive = false;
      this.editing = false;
    }
  },
  created() {
    this.fetchGigs();
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
</style>
