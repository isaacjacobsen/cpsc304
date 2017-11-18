<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
        <table style="margin-top: 3%; margin-bottom: 10%">
            <thead class="subsection-title">Update Employee Info</thead>
            <div style="margin-top: 5%">
                <div>
                    <span class="employee-header">Name: </span>
                    <span class="employee-info">{{ ename }}</span>
                </div>
                <div>
                    <span class="employee-header">Employee ID: </span>
                    <input style="margin-left: 34px" type="number" :value="employeeid" v-model="employeeid">
                    <button style="margin-top: 2%" type="button" class="button--grey" @click="getEmployee">Get Employee</button>
                </div>
                <div>
                    <span class="employee-header">Bimonthly Wage: </span>
                    <input v-if="(bimonthly_wage !== '')" type="number" :value="bimonthly_wage" v-model="bimonthly_wage">
                    <button type="button" class="button--grey" @click="updateWage">Update Wage</button>
                </div>
                <div>
                    <span class="employee-header">YTD Earnings: </span>
                    <span class="employee-info">{{ yearlypay }}</span>
                </div>
                <div>
                    <span class="employee-header">Position: </span>
                    <span class="employee-info">{{ employeetype }}</span>
                </div>
                <div>
                    <span class="employee-header">Wards: </span>
                    <div style="margin-left: 15%" v-for="(ward, index) in wards" class="employee-info">
                        <span>{{ ward.ward_name }} - {{ ward.hname_short}}</span>
                        <button v-if="(ward.err !== 'no wards')" style="margin-left: 20%" @click="delFromWard(ward.wardid)">Remove From Ward</button>
                    </div>
                    <div v-if="(ename !== '')" style="margin-left: 10%">
                        <h4>Add to Ward</h4>
                        <select v-model="newWard">
                            <option disabled value="">Select Ward To Add</option>
                            <option v-for="(ward, index) in allWards" v-bind:value="ward.wardid">
                                {{ ward.ward_name }} - {{ ward.hname_short}}
                            </option>
                        </select>
                        <button @click="addToWard">Add Ward</button>
                    </div>
                </div>
                <button style="margin-top: 2%" type="button" class="button--grey" @click="goBack">Back</button>
            </div>
        </table>
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
          userid: res.data.userid,
          isAdm: (res.data.usertypeid === 1),
          isManager: (res.data.usertypeid === 2)
        }
      })
      .catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },

  data: function () {
    return {
      employee: {},
      employeeid: '',
      employeetype: '',
      ename: '',
      yearlypay: '',
      bimonthly_wage: '',
      wards: [],
      allWards: [],
      newWard: ''
    }
  },

  methods: {
    getAllWards () {
      axios.get(`/api/employees/${this.employeeid}/hos_wards`)
        .then((res) => {
          this.allWards = res.data
        }).catch((e) => {
          this.allWards = [{err: 'no available wards'}]
        })
    },
    addToWard () {
      axios.post('/api/employees/' + this.employeeid + '/add_ward/' + this.newWard, {
        headers:
          {
            'Content-Type': 'application/json'
          }
      }).then((res) => {
        // res.data should contain the url for redirecting... bad practice
        this.employeeid = res.data.employeeid
        this.getEmployee()
      }).catch((e) => {
        console.log(e)
      })
    },
    getEmployee () {
      axios.get(`/api/employees/emp_payroll/${this.employeeid}`)
        .then((res) => {
          if (res.statusCode !== 404) {
            this.employee = res.data
            this.ename = res.data.ename
            this.employeetype = res.data.employeetype
            this.yearlypay = res.data.yearlypay
            this.bimonthly_wage = res.data.bimonthly_wage
          } else {
            this.ename = 'Not valid employee ID'
          }
        })
        .catch((e) => {
          this.employee = ''
          this.ename = 'Not Valid Employee ID'
          this.employeetype = ''
          this.yearlypay = ''
          this.bimonthly_wage = ''
        })
      axios.get(`/api/employees/${this.employeeid}/emp_wards`)
        .then((res) => {
          if (res.statusCode !== 404) {
            this.wards = res.data
          }
        }).catch((e) => {
          this.wards = [{err: 'no wards'}]
        })
      this.getAllWards()
    },

    delFromWard (wardid) {
      axios.post('/api/employees/' + this.employeeid + '/del_ward/' + wardid,
        {
          headers:
            {
              'Content-Type': 'application/json'
            }
        }
      ).then((res) => {
        this.employeeid = res.data.employeeid
        this.getEmployee()
      })
    },

    updateWage () {
      axios.post('/api/employees/emp_payroll/' + this.employeeid + '/update', {
        headers:
          {
            'Content-Type': 'application/json'
          },
        data:
          {
            userid: this.userid,
            bimonthly_wage: this.bimonthly_wage
          }
      }).then((res) => {
        // res.data should contain the url for redirecting... bad practice
        self.$nuxt.$router.replace({ path: res.data })
      })
        .catch((e) => {
          console.log(e)
        })
    },

    goBack () {
      this.$nuxt.$router.replace({ path: `/users/${this.userid}/view_employees` })
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
  border-radius 1px
  transition all .5s cubic-bezier(.55,0,.1,1)
  padding 10px 10px 10px 10px
  position relative
  line-height 20px
  .subsection-title
    margin-top 3%
    margin-bottom 2%
    font-size 26px
    font-weight 500
  .employee-header
    padding 20px 30px 10px 30px
    margin 60px 25px
    font-size 18px
    font-weight 300
    color #0d5a94
  .employee-info
    margin-left 45px
    font-size 18px
    font-weight 300
    color #707070
  a
    text-decoration underline
    &:hover
      color #515ec4

</style>
