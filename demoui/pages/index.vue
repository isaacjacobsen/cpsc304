<template>
  <div class="wrapper">
      <div class="container">
        <form class="form">
          <h1 style="font-weight: 700; padding: 0 0 30px 0; color: white">UBC Hospital System</h1>
          <input type="text" :value="username" placeholder="User Name" v-model="username"/>
          <input type="password" v-model="password" placeholder="password"/>
          <button type="button" id="login" @click="attemptLogin">Login</button>
        </form>
    </div>
  </div>
</template>

<script>
import Logo from '~/components/Logo.vue'
import axios from '~/plugins/axios'

export default {
  components: {
    Logo
  },
  data () {
    return {
      username: '',
      password: ''
    }
  },

  methods: {
    attemptLogin () {
      axios.get('/api/users' + '?username=' + this.username + '&password=' + this.password)
        .then((res) => {
          // res.data should contain the url for redirecting... bad practice
          self.$nuxt.$router.replace({ path: '/users/' + res.data.userid })
        })
        .catch((e) => {
          console.log(e)
        })
    }
  }
}
</script>

<style lang="stylus" scoped>

  body {
    font-family: 'Source Sans Pro', sans-serif;
    color: white;
    font-weight: 300;
    margin: 0px;
  }
  .wrapper {
    background-image: url("../assets/img/de1_0506.jpg");
    height: 100%;
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
    position: absolute;
    width: 100%;
    overflow: hidden;
  }
  .wrapper.form-success .container h1 {
    -webkit-transform: translateY(85px);
    transform: translateY(85px);
  }
  .container {
    max-width: 600px;
    margin: 0 auto;
    padding: 150px 0;
    height: 100px;
    text-align: center;

  }
  .container h1 {
    font-size: 40px;
    -webkit-transition-duration: 1s;
    transition-duration: 1s;
    font-weight: 200;
  }
  form {
    border-radius: 15px;
    background: rgba(0, 0, 0, 0.87);
    padding: 40px 0;
    position: relative;
    z-index: 2;
  }
  .card {
    box-shadow: 0 14px 18px 0 rgba(0,0,0,0.2);
    transition: 0.3s;
    border-radius: 15px; /* 5px rounded corners */
  }
  form input {
    outline: 0;
    border: 1px solid rgba(255, 255, 255, 0.4);
    background-color: rgba(255, 255, 255, 0.63);
    width: 250px;
    border-radius: 3px;
    padding: 10px 15px;
    margin: 0 auto 10px auto;
    display: block;
    text-align: center;
    font-size: 18px;
    color: white;
    -webkit-transition-duration: 0.25s;
    transition-duration: 0.25s;
    font-weight: 300;
  }
  form input:hover {
    background-color: rgba(157, 157, 157, 0.67);
  }
  form input:focus {
    border-color: black;
    background-color: #ffffff;
    width: 300px;
    color: #c40216;
  }
  form button {
    outline: 0;
    background-color: rgb(255, 255, 255);
    border: 0;
    padding: 10px 15px;
    color: #000000;
    border-radius: 3px;
    width: 250px;
    cursor: pointer;
    font-size: 18px;
    -webkit-transition-duration: 0.25s;
    transition-duration: 0.25s;
  }
  form button:hover {
    background-color: #f5f7f9;
  }
</style>
