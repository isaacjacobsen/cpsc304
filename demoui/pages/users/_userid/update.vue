<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
        <form style="margin: 15px 15px;">
            <div style="margin: 10px 0;">
                <span class="user-name">Name: </span>
                <input type="text" :value="user.name" v-model="user.name">
            </div>
            <div style="margin: 10px 0;">
              <span class="user-username">Username: </span>
              <input type="text" :value="user.username" v-model="user.username">
            </div>
            <div style="margin: 10px 0;">
              <span class="user-password">Password: </span>
              <input type="password" v-model="user.password">
            </div>
            <div v-if="is_emp||is_pat" style="margin: 10px 0;">
                <span  class="user-phonenum">Phone Number: </span>
                <input :value="phone_num" v-model="phone_num">
            </div>
            <div v-if="is_emp||is_pat" style="margin: 10px 0;">
                <span  class="user-address">Address: </span>
                <input type="text" :value="address" v-model="address">
            </div>
            <div v-if="is_emp||is_pat" style="margin: 10px 0;">
                <span class="user-postcode">Postal Code: </span>
                <input type="text" :value="postal_code" v-model="postal_code">
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
          phone_num: res.data.phone_num,
          address: res.data.address,
          postal_code: res.data.postal_code,
          is_emp: res.data.isemployee,
          is_pat: res.data.ispatient
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
            phoneNum: self.phone_num,
            address: self.address,
            postCode: self.postal_code
          }
      }).then((res) => {
        // res.data should contain the url for redirecting... bad practice
        self.$nuxt.$router.replace({ path: res.data })
      })
        .catch((e) => { console.log(e) })
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
