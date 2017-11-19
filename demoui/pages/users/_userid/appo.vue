<template>
  <section class="user-view">
  <div class="content">
    <div class="subsection">
    <form style="margin: 15px 15px;">
      <div style="margin: 10px 0;">
        <span style="color: #47494e; font-weight: 600; font-size: 40px; padding: 0 0 30px 0;">Appointment Centre<br><br></span>

        <div>
          <span style="cursor: pointer" class="user-username" @click="togglePatientSearch">Search Appointments For Patient</span>
          <br>
          <div v-if="showPatientSearch">
            <input v-if="showPatientSearch" type="text" v-model="pname"/>
            <br>
            <button style="margin: 5px 0 0 0" v-if="showPatientSearch" type="button" class="button--grey" @click="searchPname()">Search</button>
            <table class="paleBlueRows" v-if="res && res.length">
              <tbody>
              <tr>
                <th>Name</th>
              </tr>
              <tr v-for="items in res">
                <td>{{ items.ename }}</td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>
        
        <div>
          <br>
          <span style="cursor: pointer" class="user-username" @click="toggleAddAppointment
    ">Add An Appointment</span>
          <br>
          <div v-if="showAddAppointment" style="margin: 10px 0;">

            <span class="user-type" style="color: black">Patient Name:</span>
            <input type="text" style="margin-right: 80%" v-model="pnameApt"/>
            <br><br>

            <span class="user-type"  style="color: black">Patient Phone Number:</span>
            <br>
            <span style="color: black">
              (<input type="text" style="width: 30px" v-model="pphone[0]"/>)-
              <input type="text" style="width: 30px" v-model="pphone[1]"/>-
              <input type="text" style="width: 40px" v-model="pphone[2]"/>
            </span>
            <br><br>

            <span class="user-type"  style="color: black">Appointment time:</span>
            <br>
            <span style="color: black">
              <input type="text" style="width: 20px" v-model="aptTime[0]"/> /
              <input type="text" style="width: 26px" v-model="aptTime[1]"/> /
              <input type="text" style="width: 35px" v-model="aptTime[2]"/>&nbsp;
              <input type="text" style="width: 20px" v-model="aptTime[3]"/>:
              <input type="text" style="width: 26px" v-model="aptTime[4]"/>
            </span>
            <br><br>

            <button style="margin: 5px 0 0 0;" type="button" class="button--grey" @click="bookNew">Add Appointment</button>
            
          </div>
        </div>

        <div>
          <br>
          <span style="cursor: pointer" class="user-username" @click="showAll">Show All Appointments<br></span>
          <table class="paleBlueRows"  v-if="allRes && allRes.length && showAllAppointments">
            <tbody>
            <tr>
              <th>Appointment<br>Count</th>
              <th>Employee<br>ID</th>
              <th>Employee<br>Name</th>
              <th>Employee<br>Type</th>
            </tr>
            <tr v-for="items in allRes">
              <td class="">{{ items.appointmentcount }}</td>
              <td class="">{{ items.employeeid }}</td>
              <td class="">{{ items.employeename }}</td>
              <td class="">{{ items.employeetype }}</td>
            </tr>
            </tbody>
          </table>
        </div>
        <button style="margin: 5px 0 0 0" type="button" class="button--grey" @click="goBack">Back</button>
      </div>
    </form>


    </div>
  </div>
  </section>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  name: 'userid',
  asyncData ({ params, error }) {
    return axios.get('/api/users/' + params.userid)
      .then((res) => {
        return {
          userid: res.data.userid,
          employeeid: res.data.id,
          show: (res.data.doctor_type !== null || res.data.nurse_type !== null),
          isAdm: res.data.isadmin,
          isManager: res.data.ismanager
        }
      })
      .catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },
  data () {
    return {
      pname: '',
      showlist: false,
      res: [],
      allRes: [],
      pnameApt: '',
      pphone: ['', '', ''],
      aptTime: [],
      showPatientSearch: false,
      showAddAppointment: false,
      showAllAppointments: false
    }
  },
  methods: {
    toggleAddAppointment () {
      this.showAddAppointment = !this.showAddAppointment
      this.showPatientSearch = false
      this.showAllAppointments = false
    },
    togglePatientSearch () {
      this.showPatientSearch = !this.showPatientSearch
      this.showAddAppointment = false
      this.showAllAppointments = false
    },
    getPhoneString () {
      if (!isNaN(this.pphone[0]) && !isNaN(this.pphone[1]) && !isNaN(this.pphone[2]) && String(this.pphone[0]).length.toString() === '3' && String(this.pphone[1]).length.toString() === '3' && String(this.pphone[2]).length.toString() === '4') {
        return '(' + String(this.pphone[0]) + ')-' + String(this.pphone[1]) + '-' + String(this.pphone[2])
      }

      alert('Please enter valid phone number')
      return null
    },
    getDateString () {
      for (var i in this.aptTime) {
        if (isNaN(this.aptTime[i])) {
          alert('Please enter valid appointment time')
          return null
        }

        if (i === '2' && String(this.aptTime[i]).length.toString() !== '4') {
          alert('Please enter valid appointment time length1 ' + i + ': ' + String(this.aptTime[i]).length)
          return null
        }

        if (i !== '2' && String(this.aptTime[i]).length.toString() !== '2') {
          alert('Please enter valid appointment time length2 ' + i + ': ' + String(this.aptTime[i]).length)
          return null
        }
      }

      var day = Number(this.aptTime[0])
      var month = Number(this.aptTime[1])
      var year = Number(this.aptTime[2])
      var hour = Number(this.aptTime[3])
      var minute = Number(this.aptTime[4])

      if (month <= Number(0.9) || month >= Number(12.1)) {
        alert('Month is invalid')
        return null
      }

      if (day <= Number(0.9) || day >= Number(31.1)) {
        alert('Day is invalid')
        return null
      }

      if (year <= Number(2016)) {
        alert('Year is invalid')
        return null
      }

      if (hour <= Number(-0.1) || hour >= Number(23.1)) {
        alert('Hour is invalid')
        return null
      }

      if (minute <= Number(-0.1) || minute >= Number(59.1)) {
        alert('Hour is invalid')
        return null
      }

      return String(this.aptTime[0]) + '/' + String(this.aptTime[1]) + '/' + String(this.aptTime[2]) + ' ' + String(this.aptTime[3]) + ':' + String(this.aptTime[4])
    },
    searchPname () {
      axios.get('/api/appo/' + this.pname).then((res) => {
        // res.data should contain the url for redirecting... bad practice
        // self.$nuxt.$router.replace({ path: res.data })
        console.log(res)
        console.log(res.data)
        this.res = res.data
        this.showlist = true
      })
        .catch(error => {
          if (error.response) {
            // Response has been received from the server
            alert('no appointments found under this name')
            console.log(error.response.data)
          }
        })
    },
    showAll () {
      this.showAllAppointments = !this.showAllAppointments
      this.showPatientSearch = false
      this.showAddAppointment = false

      axios.get('/api/showall').then((res) => {
        // res.data should contain the url for redirecting... bad practice
        // self.$nuxt.$router.replace({ path: res.data })
        this.allRes = res.data
        this.showalllist = true
      })
        .catch(error => {
          if (error.response) {
            // Response has been received from the server
            alert('nothing to show!')
            console.log(error.response.data)
          }
        })
    },
    bookNew () {
      var phoneNumber = this.getPhoneString()
      var appointmentTime = this.getDateString()

      if (phoneNumber && appointmentTime && this.pnameApt.length > 0) {
        console.log('Posting to employees: ' + '/api/employees/' + this.employeeid + '/appointments')
        axios.post('/api/employees/' + this.employeeid + '/appointments', {
          headers:
          {
            'Content-Type': 'application/json'
          },
          data:
            {
              pnameApt: this.pnameApt,
              pphone: phoneNumber,
              aptTime: appointmentTime
            }}).then((res) => {
          console.log(res)
          console.log(res.data)
          alert('Appintment Booked!')
        })
          .catch(error => {
            if (error.response) {
              // Response has been received from the server
              alert('Error')
              console.log(error.response.data)
            }
          })
      }
    },
    goBack () {
      this.$nuxt.$router.replace({ path: `/users/${this.userid}` })
    }
  },

  head () {
    return {
      title: `Welcome: Appointment Booking System`
    }
  }
}
</script>

<style lang="stylus">
.user-view
  padding-top 0

.content
  position absolute
  width 100%

.subsection
  background-color #fff
  border-radius 2px
  margin 25px 0
  transition all .5s cubic-bezier(.55,0,.1,1)
  padding 10px 30px 10px 30px
  position relative
  line-height 20px
  .subsection-title
    margin 25px 10px
    font-size 26px
    font-weight 500
  .user-username
    font-size 24px
    font-weight 500
    color #707070
  .user-password
    font-size 24px
    font-weight 500
    color #707070
  a
    text-decoration underline
  &:hover
    color #515ec4

table.paleBlueRows {
  font-family: "Times New Roman", Times, serif;
  border: 1px solid #FFFFFF;
  width: 350px;
  height: 200px;
  text-align: center;
  border-collapse: collapse;
}
table.paleBlueRows td, table.paleBlueRows th {
  border: 1px solid #FFFFFF;
  padding: 3px 2px;
}
table.paleBlueRows tbody td {
  font-size: 13px;
}
table.paleBlueRows tr:nth-child(even) {
  background: #D0E4F5;
}
table.paleBlueRows thead {
  background: #0B6FA4;
  border-bottom: 5px solid #FFFFFF;
}
table.paleBlueRows thead th {
  font-size: 17px;
  font-weight: bold;
  color: #FFFFFF;
  text-align: center;
  border-left: 2px solid #FFFFFF;
}
table.paleBlueRows thead th:first-child {
  border-left: none;
}

table.paleBlueRows tfoot {
  font-size: 14px;
  font-weight: bold;
  color: #333333;
  background: #D0E4F5;
  border-top: 3px solid #444444;
}
table.paleBlueRows tfoot td {
  font-size: 14px;
}
</style>
