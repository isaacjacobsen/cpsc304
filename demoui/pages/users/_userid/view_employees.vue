<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
          <span class="subsection-title">List of Employees</span>
          <br>
          <div style="margin-top: 3%">
              <h3>Search By 3-digit Hospital Code</h3>
              <input type="text" :value="hospitalcode" v-model="hospitalcode">
              <br>
              <button style="margin: 5px 0 0 0" type="button" class="button--grey" @click="searchByHospital">Search Hospital</button>
          </div>
          <div style="margin-top: 3%">
              <h3>Search By Ward ID</h3>
              <input type="text" :value="wardid" v-model="wardid">
              <br>
              <button style="margin: 5px 0 0 0" type="button" class="button--grey" @click="searchByWard">Search Ward</button>
          </div>
          <div style="margin-top: 3%">
              <h3>Search For Specialist</h3>
              <span>Works in same hospital as Doctor (name):</span>
              <br>
              <input type="text" :value="doctorname" v-model="doctorname">
              <br>
              <span>Specialty:</span>
              <br>
              <input type="text" :value="specialty" v-model="specialty">
              <br>
              <button style="margin: 5px 0 0 0" type="button" class="button--grey" @click="searchBySpecialty">Search For Doctors</button>
          </div>
          <br>
            <table v-if="showByHospital || showByWard" style="margin-top: 3%; margin-bottom: 5%">
              <tbody>
                <tr class="employee-header">
                    <th>Employee Name</th>
                    <th>EID</th>
                    <th>Bimonthly Wage</th>
                    <th>YTD Earnings</th>
                    <th>Employee Type</th>
                    <th v-if="showByHospital">Hospital</th>
                    <th v-if="showByWard">Ward</th>
                </tr>
                <tr v-for="(employee, index) in employees">
                    <td class="employee-name">{{ employee.ename }}</td>
                    <td class="employee-info">{{ employee.employeeid }}</td>
                    <td class="employee-info">{{ employee.bimonthly_wage }}</td>
                    <td class="employee-info">{{ employee.yearlypay }}</td>
                    <td class="employee-info">{{ employee.employeetype }}</td>
                    <td v-if="showByHospital" class="employee-info">{{ employee.hname_short }}</td>
                    <td v-if="showByWard" class="employee-info">{{ employee.ward_name }} - {{ employee.hname_short}}</td>
                </tr>
              </tbody>
            </table>
            <table v-if="showBySpecialty" style="margin-top: 3%; margin-bottom: 5%">
              <tbody>
                <tr class="employee-header">
                    <th>Doctor Name</th>
                    <th>EID</th>
                    <th>Hospital Code</th>
                    <th>Specialty</th>
                </tr>
                <tr v-for="(doctor, index) in doctors">
                    <td class="employee-name">{{ doctor.ename }}</td>
                    <td class="employee-info">{{ doctor.employeeid }}</td>
                    <td class="employee-info">{{ doctor.hname_short }}</td>
                    <td class="employee-info">{{ doctor.doctor_type }}</td>
                </tr>
              </tbody>
            </table>
        <button style="margin: 0" type="button" class="button--grey" @click="updatePayroll">Update Employee</button>
        <button style="margin: 0 0 0 10px" type="button" class="button--grey" @click="goBack">Back</button>
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
      showByHospital: false,
      showByWard: false,
      showBySpecialty: false,
      hospitalcode: '',
      wardid: '',
      doctorname: '',
      specialty: ''
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
      this.showByWard = false
      this.showBySpecialty = false
      return axios.get('/api/employees/hos/' + String(this.hospitalcode).toUpperCase())
        .then((res) => {
          this.showByHospital = true
          this.employees = res.data
        })
        .catch((e) => {
          this.showByHospital = false
          this.employees = null
          alert('No employees in hospital')
        })
    },
    searchByWard () {
      this.showByHospital = false
      this.showBySpecialty = false
      return axios.get('/api/employees/ward/' + this.wardid)
        .then((res) => {
          this.showByWard = true
          this.employees = res.data
        })
        .catch((e) => {
          this.showByWard = false
          this.employees = null
          alert('No employees in ward')
        })
    },
    searchBySpecialty () {
      this.showByHospital = false
      this.showByWard = false

      return axios.get('/api/employees?doctorname=' + this.doctorname.replace(' ', '-') + '&specialty=' + this.specialty.replace(' ', '-'))
        .then((res) => {
          this.showBySpecialty = true
          this.doctors = res.data
        })
        .catch((e) => {
          this.showByWard = false
          this.doctors = null
          alert('No ' + this.specialty + 's work in the same hospital as ' + this.doctorname)
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
