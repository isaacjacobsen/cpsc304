<template>
  <section class="user-view">
  <div class="content">
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
      <div style="margin: 10px 0;">
        <span class="user-type">User Type: </span>
        <select v-model="typeid">
          <option disabled value="">Select Usertype</option>
          <option value=5>Patient</option>
          <option value=4>Nurse</option>
          <option value=3>Doctor</option>
          <option value=2>Manager</option>
          <option value=1>System Admin</option>
        </select>
      </div>
    </form>
    <button type="button" class="button--grey" @click="submitInsert">Add User</button>
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
          userid: res.data.userid
        }
      })
      .catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },

  data () {
    return {
      username: '',
      password: '',
      typeid: ''
    }
  },

  methods: {
    submitInsert () {
      let self = this

      axios.post('/api/users/add', {
        headers:
          {
            'Content-Type': 'application/json'
          },
        data:
          {
            username: self.username,
            password: self.password,
            typeid: self.typeid
          }})
        .then((res) => {
          // res.data should contain the url for redirecting... bad practice
          console.log(res)
          self.$nuxt.$router.replace({ path: `/users/${self.userid}` })
        })
        .catch((e) => {
          console.log(e)
        })
    },

    goBack () {
      let self = this
      this.$nuxt.$router.replace({ path: `/users/${self.userid}` })
    }
  },

  head () {
    return {
      title: `Add New User`
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
  .user-type
    font-size 24px
    font-weight 500
    color #707070
  a
    text-decoration underline
  &:hover
    color #515ec4

</style>
