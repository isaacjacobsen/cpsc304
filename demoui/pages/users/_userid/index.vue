
<template>
  <div style="background: rgb(37, 73, 142)">
  <div id=header>
    <div class="container" id="head">
      <div class="icon2" style="text-shadow: 0 0 20px 20px rgba(0,0,0,0.1);">UBC</div>
      <div class="icon" style="text-shadow: 0 0 20px 20px rgba(0,0,0,0.1);">+</div>
    </div>
  </div>
  <div id="wrap">
    <p class="wrap text"><br>UBC Hospital System <br> Welcome {{ user.loginname }} <br><br></p>

    <div>
      <main>
        <form id="main-form">
          <h2 style="color: black"><b>User Type: {{ user.usertypename }}</b></h2>

          <h2 v-if="(this.user.doctor_type !== null)" style="color: black;">Ward: {{ user.doctor_type }}</h2>
          <h2 v-if="(this.user.nurse_type !== null)" style="color: black;">Ward: {{ user.nurse_type }}</h2>
          <hr>
          <h3 style="color: black;">I Want To:</h3>
          <div style="padding-left: 40%">
          <div style="text-align: left">

          <input id="toggle1" name="compType" value="1" type="radio" v-model="selections">
          <label for="toggle1" style="color: black">Update My Information</label>

          <div  v-if="show"><br></div>
          <input v-if="show" id="toggle2" name="compType" value="2" type="radio" v-model="selections">
          <label v-if="show" for="toggle2" style="color: black;">Check Appointments</label>

          <div v-if="isManager"><br></div>
          <input v-if="isManager" id="toggle3" name="compType" value="3" type="radio" v-model="selections">
          <label v-if="isManager" for="toggle3" style="color: black;">Manage Employee</label>

          <div v-if="isAdm"><br></div>
          <input v-if="isAdm" id="toggle4" name="compType" value="4" type="radio" v-model="selections">
          <label v-if="isAdm" for="toggle4" style="color: black;">Add New User</label>

          <div v-if="isManager"><br></div>
          <input v-if="isManager" id="toggle5" name="compType" value="5" type="radio" v-model="selections">
          <label v-if="isManager" for="toggle5" style="color: black;">View This Month's Patients</label>
		  
          <div v-if="isManager"><br></div>
          <input v-if="isManager" id="toggle6" name="compType" value="6" type="radio" v-model="selections">
          <label v-if="isManager" for="toggle6" style="color: black;">View Inpatients</label>
          </div></div>

          <p></p>
          <input type="button" value = "Continue" @click='doTask'/>
          <br>
          <input type="button" value="Log Out"  @click="logoutUser" />
        </form>
      </main>
      <div id="placeholder"></div>
      <br><br><br>
    </div>
  </div>
    <footer>
      <p align="center">&copy; 2017 | Team 50 | All Rights Reserved</p>
      <p align="center">A Demo Webpage For CPSC 304 Project</p>
    </footer>
  </div>
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
          isAdm: res.data.isadmin,
          isManager: res.data.ismanager
        }
      }).catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },
  head () {
    return {
      title: `User: ${this.user.username}`
    }
  },
  data () {
    return {
      selections: ''
    }
  },
  methods: {
    doTask () {
      if (this.selections === '1') this.updateUser()
      else if (this.selections === '2') this.doAppo()
      else if (this.selections === '3') this.viewEmployees()
      else if (this.selections === '4') this.addUser()
      else if (this.selections === '5') this.viewPatient()
      else if (this.selections === '6') this.viewInpatient()
      else {
        alert('Please make a selection before continue')
      }
    },
    addUser () {
      self.$nuxt.$router.replace({ path: `/users/${this.user.userid}/add` })
    },
    updateUser () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}/update` })
    },
    doAppo () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}/appo` })
    },
    viewEmployees () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}/view_employees` })
    },
    logoutUser () {
      this.user = {}
      this.$nuxt.$router.replace({ path: '/' })
    },
    viewPatient () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}/currmonthpatients` })
    },
    viewInpatient () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}/inpatients` })
    }
  }
}
</script>

<style scoped>

  .text {
    background-color: #ff443d;
    color: white;
    font-size: 16px;
    padding: 15px 80px;
  }

  table {
    border-collapse: collapse;
    width: 100%;
  }

  th, td {
    text-align: left;
    padding: 8px;
  }

  tr:nth-child(even){background-color: #f2f2f2}

  input[type=text], select {
    width: auto;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #000000;
    border-radius: 4px;
    box-sizing: border-box;
  }

  input[type=button] {
    width: 30%;
    background-color: #ff443d;
    color: #ffffff;
    padding: 8px 10px;
    margin: 8px 0;
    border: none;
    border-radius: 10px;
  }

  input[type=button]:hover {
    background-color: #730612;
  }

  input[type=search] {
    width: 50%;
    background-color: #ff443d;
    color: #ffffff;
    padding: 8px 10px;
    margin: 8px 0;
    border: none;
    border-radius: 10px;
  }

  input[type=search]:hover {
    background-color: #730612;
  }

  div.special {
    width: 70%;
    color: #ffffff;
    border-radius: 15px;
    background-color: #f1f2f4;
    padding: 20px;
  }

  body, html {
    height: 900px;
    background: rgb(37, 73, 142) !important;
    font-family: "Helvetica Neue", helvetica, arial, sans-serif;
  }

  #wrap{
    position: relative;
    width:80%;
    height:auto;
    background-color: #fafafa;
    margin: 5px auto;
    border-radius: 30px;
    box-shadow: 0 0 20px 20px rgba(0,0,0,0.1);
    font-family: 'Open Sans', sans-serif;
  }

  .wrap.text {
    text-align: center;
    background-color: #000000;
    text-shadow: black;
    font-family: 'Open Sans', sans-serif;
    color: white;
    font-size: 25px;
    font-weight: 700;
    border-top-left-radius: 28px;
    border-top-right-radius: 28px;
  }
  main {
    background: #e7e7e7;
    width: 90%;
    margin: 20px auto;
    padding: 10px 0;
    box-shadow: 0 5px 5px rgba(0,0,0,0.3);
    text-align: center;
    border-radius: 20px;
  }
  main.h2 {
    color: black;
  }
  main.p {
    font-size: 13px;
    color: black;
    text-align: left;

  }
  main.input {
    display: none;
    visibility: hidden;
  }
  main.label {
    margin-left: 0;
    alignment: left;
    display: block;
    padding: 0.5em;
    border-bottom: 1px solid #000000;
    color: #000000;
  }
  main.label:hover {
    color: #0082ff;
  }
  main.label::before {
    font-family: Consolas, monaco, monospace;
    font-weight: bold;
    font-size: 15px;
    vertical-align: text-top;
    display: inline-block;
    width: 20px;
    height: 20px;
    margin-right: 3px;
    background: radial-gradient(ellipse at center, #CCC 50%, transparent 50%);
  }

  #expand1 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggle1:checked ~ #expand1 {
    height: 55px;
  }

  #expand2 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggle2:checked ~ #expand2 {
    height: 55px;
  }

  #expand3 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggle3:checked ~ #expand3 {
    height: 55px;
  }

  #expand4 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggle4:checked ~ #expand4 {
    height: 55px;
  }

  #expand5 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggle5:checked ~ #expand5 {
    height: 55px;
  }

  #expandMedium1 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggleMedium1:checked ~ #expandMedium1 {
    height: 80px;
  }

  #expandMedium2 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggleMedium2:checked ~ #expandMedium2 {
    height: 80px;
  }

  #expandMedium3 {
    height: 0;
    overflow: hidden;
    transition: height 0.5s;
    color: #000000;
  }
  #toggleMedium3:checked ~ #expandMedium3 {
    height: 120px;
  }

  #expandLarge {
    display: none;
    height: auto;
    overflow: hidden;
    color: #000000;
  }
  #sectionsToggle:checked ~ #expandLarge {
    display: block;
  }

  main.section {
    padding: 0 20px;
  }

  input[type="checkbox"]{
    cursor: pointer;
    -webkit-appearance: none;
    background: #4e4e4e;
    border-radius: 7px;
    box-sizing: border-box;
    position: relative;
    width: 30px;
    height: 30px;
    border-width: 0;
    transition: all .3s linear;
  }
  input[type="checkbox"]:hover {
    background-color: #b1a8ab;
  }
  input[type="checkbox"]:checked{
    background-color: #143b5e;
  }
  input[type="checkbox"]:focus{
    outline: 0 none;
    box-shadow: none;
  }

  table {
    color: #333; /* Lighten up font color */
    font-family: Helvetica, Arial, sans-serif; /* Nicer font */
    width: 30%;
    border-collapse: collapse; border-spacing: 0;
  }

  td, th { border: 3px solid #CCC; height: 30px; } /* Make cells a bit taller */

  th {
    background: #F3F3F3; /* Light grey background */
    font-weight: bold; /* Make sure they're bold */
  }

  td {
    background: #FAFAFA; /* Lighter grey background */
    text-align: center; /* Center our text */
  }


  .icon {
    font-family: "Helvetica Neue", helvetica, arial, sans-serif;
    color: #fff;
    padding: 0 0 30px 0;
    background-color: rgb(255, 56, 56);
    height: 90px;
    width: 180px;
    font-size: 150px;
    font-weight: 900;
    line-height: 90px;
    text-align: center;
    border-radius: 15px;
    overflow: hidden;
    text-shadow: 2px 2px 2px #000;
    display: inline-block;
    -webkit-transition: all .2s linear;
    transition: all .2s linear;
  }

  .icon:hover{
    box-shadow: 0 0 30px #ff3e31;
    background-color: #ff3e31;
  }

  .icon2 {
    font-family: "Helvetica Neue", helvetica, arial, sans-serif;
    font-weight: bold;
    color: #fff;
    background-color: rgba(255, 90, 65, 0);
    height: 100px;
    width: 250px;
    font-size: 100px;
    line-height: 100px;
    text-align: center;
    overflow: hidden;
    text-shadow: 2px 2px 2px #000;
    display: inline-block;
  }

  .container {
    position: relative;
    text-align: center;
    margin: 0 0 0 0;
    padding: 50px;
    background: rgb(37, 73, 142);
  }

  .container.text{

    position: relative;
    text-align: center;
    font-family: "Helvetica Neue", helvetica, arial, sans-serif;
    font-weight: bold;
    color: #fff;
    margin: 0 0 0 0;
    padding: 50px;
    font-size: 20px;
    display: block;
    background: rgb(37, 73, 142);
  }

  footer{
    border: 0;
    font-family: "Helvetica Neue", helvetica, arial, sans-serif;
    color: #fff;
    margin: 0 0 0 0;
    padding: 50px;
    font-size: 20px;
    display: block;
    background: rgb(37, 73, 142);
  }

</style>
