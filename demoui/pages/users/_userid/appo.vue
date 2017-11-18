<template>
  <section class="user-view">
  <div class="content">
    <div class="subsection">
    <form style="margin: 15px 15px;">
      <div style="margin: 10px 0;">
        <span style="color: #47494e; font-weight: 600; font-size: 40px; padding: 0 0 30px 0;">Appointment Centre<br><br></span>

        <table class="paleBlueRows"  v-if="allRes && allRes.length">
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

        <span class="user-username">Patient's Name: <br></span>
        <input type="text" v-model="pname"/>
        <button type="button" class="button--grey" @click="searchPname()">Search</button>


        <table class="paleBlueRows" v-if="res && res.length">
          <span style="color: black; !important;">List of Employees that have appointment with patient {{pname}}</span>
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
      <hr>
      <span class="user-username" >Add an appointment: <br></span>
      <br>
      <div style="margin: 10px 0;">
        <ul>
          <li><span class="user-type" style="color: black">Visit ID: </span>
            <br>
            <input type="text" style="margin-right: 80%" v-model="pid"/><br></li>
          <li><span class="user-type"  style="color: black">Appointment time: </span>
            <input type="text" style="margin-right: 80%" v-model="appTime"/><br></li>
          <li><span class="user-type"  style="color: black">Writeup Link: </span>
            <input type="text" style="margin-right: 80%" v-model="link"/></li>
        </ul>
        <br>
        <button type="button" class="button--grey" @click="bookNew">Book New Appointment</button>
      </div>

      <hr>
      <span class="user-username" >Display all employees who have appointments: <br></span>
    </form>
    <button type="button" class="button--grey" @click="showAll">Show All Appointments</button>


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
          user: res.data,
          show: (res.data.doctor_type !== null || res.data.nurse_type !== null),
          isAdm: (res.data.usertypeid === 1),
          isManager: (res.data.usertypeid === 2),
          pname: ''
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
      pid: '',
      appTime: '',
      link: ''
    }
  },
  methods: {
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
      axios.post('/api/addAppo/', {
        headers:
        {
          'Content-Type': 'application/json'
        },
        data:
          {
            pid: this.pid,
            appTime: this.appTime,
            link: this.link
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

  head () {
    return {
      title: `Welcome: Appointment Booking System`
    }
  }
}
</script>

<style lang="stylus" scoped>
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
