<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
        <form style="margin: 15px 15px;">
            <div style="margin: 10px 0;">
                <span class="user-name">Name: </span>
                <input type="text" :value="user.name" v-model="user.name"></input>
            </div>
            <div style="margin: 10px 0;">
              <span class="user-username">Username: </span>
              <input type="text" :value="user.username" v-model="user.username"></input>
            </div>
            <div style="margin: 10px 0;">
              <span class="user-password">Password: </span>
              <input type="password" v-model="user.password"></input>
            </div>
            <div style="margin: 10px 0;">
                <span class="user-phonenum">Phone Number: </span>
                <input v-if="is_emp" type="text" :value="e_phone" v-model="e_phone"></input>
                <input v-if="is_pat" type="text" :value="p_phone" v-model="p_phone"></input>
            </div>
            <div style="margin: 10px 0;">
                <span class="user-address">Address: </span>
                <input v-if="is_emp" type="text" :value="e_add" v-model="e_add"></input>
                <input v-if="is_pat" type="text" :value="p_add" v-model="p_add"></input>
            </div>
            <div style="margin: 10px 0;">
                <span class="user-postcode">Postal Code: </span>
                <input v-if="is_emp" type="text" :value="e_post" v-model="e_post"></input>
                <input v-if="is_pat" type="text" :value="p_post" v-model="p_post"></input>
            </div>
        </form>
        <button type="button" class="button--grey" @click="submitUpdate">Update</button>
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
          e_phone: res.data.e_phone,
          p_phone: res.data.p_phone,
          p_add: res.data.p_add,
          e_add: res.data.e_add,
          p_post: res.data.p_post,
          e_post: res.data.e_post,
          is_emp: (res.data.usertypeid === (3 || 4)),
          is_pat: (res.data.usertypeid === 5)
        }
      })
      .catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },

  data () {
    return {}
  },

  methods: {

    submitUpdate () {
      let self = this
      let phoneNum = function () {
        if (self.e_phone !== null) {
          return self.e_phone
        } else if (self.p_phone !== null) {
          return self.p_phone
        } else {
          return null
        }
      }

      axios.post('/api/users/' + self.user.userid + '/update', {
        headers:
          {
            'Content-Type': 'application/json'
          },
        data:
          {
            userid: self.user.userid,
            username: self.user.username,
            password: self.user.password,
            name: self.user.name,
            phoneNum: phoneNum()
          }})
        .then((res) => {
          // res.data should contain the url for redirecting... bad practice
          self.$nuxt.$router.replace({ path: res.data })
        })
        .catch((e) => {
          console.log(e)
        })
    },
    goBack () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}` })
    }
  },

  head () {
    return {
      title: `Update User: ${this.user.username}`
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
    font-size 22px
    font-weight 500
    color #707070
  .user-password
    font-size 22px
    font-weight 500
    color #707070
  .user-name
    font-size 22px
    font-weight 500
    color #707070
  .user-phonenum
    font-size 22px
    font-weight 500
    color #707070
  .user-address
    font-size 22px
    font-weight 500
    color #707070
  .user-postcode
    font-size 22px
    font-weight 500
    color #707070
  a
    text-decoration underline
    &:hover
      color #515ec4

</style>
