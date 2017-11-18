<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
        <span class="user-username" style="padding: 10px 0 10px 20px; margin: 10px 0 10px 0; padding-top: 5%">{{ user.name }}</span>
        <br>
        <span class="user-type">User type: {{ user.usertypename }}</span>
        <br>
        <span v-if="(this.user.doctor_type !== null)" class="user-type">Ward: {{ user.doctor_type }}</span>
        <span v-if="(this.user.nurse_type !== null)" class="user-type">Ward: {{ user.nurse_type }}</span>
        <br><br>
        <button class="button--grey" @click="updateUser">Update Info</button>
        <button v-if="isAdm" class="button--grey" @click="addUser">Add User</button>
        <button v-if="show" class="button--grey" @click="doAppo"> Appointments</button>
        <button v-if="isManager" class="button--grey" @click="viewEmployees">View Employees</button>
        <button class="button--grey" @click="logoutUser">Logout</button>
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
          isManager: (res.data.usertypeid === 2)
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
  methods: {
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
    }
  }
}
</script>

<style lang="stylus" scoped>

.content
  position: absolute;
  width: 100%;

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
  .user-type
    font-size 20px
    font-weight 300
    color #46a2c5
    padding 10px 0 10px 20px
    margin: 10px 10 10px 0
  .user-password
    font-size 24px
    font-weight 500
    color #707070
  a
    text-decoration underline
    &:hover
      color #515ec4

</style>
