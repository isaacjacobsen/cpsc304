<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
          <br>
          <span class="subsection-title" style="margin-top: 20px">List of Patients Admitted This Month</span>
        <table style="margin-bottom: 10%;">
            <br>
			<tr class="patient-header" style="text-align: left;">
                <th style="padding-right: 10px">Patient Name</th>
                <th style="padding-right: 10px">Patient ID</th>
                <th style="padding-right: 10px">Phone Number</th>
            </tr>
            <tr v-for="(patients, index) in patients">
                <td class="patient-name">{{ patients.pname }}</td>
                <td class="patient-info">{{ patients.patientid}}</td>
                <td class="patient-info">{{ patients.phone_num }}</td>
            </tr>
        </table>
        <button type="button" class="button--grey" @click="goBack">Back</button>
      </div>
    </div>
  </section>
</template>

<script>
import axios from '~/plugins/axios'

export default {

  asyncData ({ params, error }) {
    return axios.get('/api/users/' + params.userid)
      .then((res) => {
        return {
          user: res.data,
          isAdm: (res.data.usertypeid === 1),
          isManager: (res.data.usertypeid === 2),
          patients: [],
          emp_ytd: []
        }
      })
      .catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },

  data () {
    return {
      showByHospital: false,
      showByWard: false,
      hospitalcode: '',
      wardid: ''
    }
  },

  created: function () {
    this.getPatients()
  },

  methods: {
    getPatients () {
      return axios.get('/api/currmonthpatients')
        .then((res) => {
          this.patients = res.data
        })
        .catch((e) => {
          console.log(e)
        })
    },
    goBack () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}` })
    }
  },

  head () {
    return {
    }
  }
}
</script>

<style lang='stylus' scoped>
.user-view
  padding-top 0

.content
  position absolute
  width 100%

.subsection
  background-color #fff
  border-radius 2px
  transition all .5s cubic-bezier(.55,0,.1,1)
  padding 10px 30px 10px 30px
  position relative
  line-height 20px
  .subsection-title
    margin-top 3%
    margin-bottom 2%
    font-size 26px
    font-weight 500
  .patient-header
    padding 20px 30px 10px 30px
    margin 60px 25px
    font-size 18px
    font-weight 300
    color #0d5a94
  .patient-name
    font-size 18px
    font-weight 300
    color #707070
  .patient-info
    font-size 18px
    font-weight 200
    color #707070
  a
    text-decoration underline
    &:hover
      color #515ec4

</style>
