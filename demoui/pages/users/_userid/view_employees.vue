<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
        <table style="margin-top: 3%; margin-bottom: 10%">
            <span class="subsection-title">List of Employees</span>
            <br>
            <span>Search By 3-digit Hospital Code</span>
            <input type="text" :value="hospitalcode" v-model="hospitalcode">
            <br>
            <button type="button" class="button--grey" @click="searchByHospital">Search Hospital</button>
            <br>
            <tbody>
            <tr class="employee-header">
                <th>Employee Name</th>
                <th>EID</th>
                <th>Bimonthly Wage</th>
                <th>YTD Earnings</th>
                <th>Employee Type</th>
                <th>Hospital</th>
            </tr>
            <tr v-for="(employee, index) in employees">
                <td class="employee-name">{{ employee.ename }}</td>
                <td class="employee-info">{{ employee.employeeid }}</td>
                <td class="employee-info">{{ employee.bimonthly_wage }}</td>
                <td class="employee-info">{{ employee.yearlypay }}</td>
                <td class="employee-info">{{ employee.employeetype }}</td>
                <td class="employee-info">{{ employee.hname_short }}</td>
            </tr>
            </tbody>
        </table>
        <button type="button" class="button--grey" @click="updatePayroll">Update Employee</button>
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
          employees: [],
          emp_ytd: []
        }
      })
      .catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },

  data () {
    return {
      hospitalcode: ''
    }
  },

  created: function () {
    this.getEmployees()
  },

  methods: {
    getEmployees () {
      return axios.get('/api/employees')
        .then((res) => {
          this.employees = res.data
        })
        .catch((e) => {
          console.log(e)
        })
    },
    searchByHospital () {
      return axios.get('/api/employees/' + this.hospitalcode)
        .then((res) => {
          this.employees = res.data
        })
        .catch((e) => {
          this.employees = null
          alert('No employees in hospital')
        })
    },
    updatePayroll () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}/update_payroll` })
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
  .employee-header
    padding 20px 30px 10px 30px
    margin 60px 25px
    font-size 18px
    font-weight 300
    color #0d5a94
  .employee-name
    font-size 18px
    font-weight 300
    color #707070
  .employee-info
    font-size 12px
    font-weight 200
    color #707070
  a
    text-decoration underline
    &:hover
      color #515ec4

</style>
