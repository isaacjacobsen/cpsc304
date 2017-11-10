<template>
  <section class="container">
    <div>
    <Logo />
      <h1 class="title">
        Hospital System
      </h1>
      <div class="subsection">
        <form style="margin: 15px 15px;">
            <div style="margin: 10px 0;">
              <span class="user-username">Username: </span>
              <input type="text" :value="username" v-model="username"></input>
            </div>
            <div style="margin: 10px 0;">
              <span class="user-password">Password: </span>
              <input type="password" v-model="password"></input>
            </div>
        </form>
        <button type="button" class="button--grey" @click="attemptLogin">Login</button>
      </div>
    </div>
  </section>
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
.container
  min-height 90vh
  display flex
  justify-content center
  align-items center
  text-align center

@media (min-height 1080px)
  .container
    margin-top -200px

.title
  font-family "Quicksand", "Source Sans Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif /* 1 */
  display block
  font-weight 300
  font-size 100px
  color #35495e
  letter-spacing 1px

.subtitle
  font-weight 300
  font-size 42px
  color #526488
  word-spacing 5px
  padding-bottom 15px

.links
  padding-top 15px

@media (max-width 860px)
  .title
    font-size 64px
  .subtitle
    font-size 32px

@media (max-width 860px)
  .links
    .link
      width 50%
      margin-bottom 15px
      display relative
</style>
