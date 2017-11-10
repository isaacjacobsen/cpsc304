<template>
  <section class="user-view">
    <div class="content">
      <div class="subsection">
        <tr style="padding-left: 20px"> Welcome! </tr>
        <!--Need to create a view so that this is casted to more descriptive usertype-->
        <td class="user-type" style="padding: 10px 0 10px 10px; margin: 10px 0 10px 0;">{{ user.typeid }}</td>
        <td class="user-username" style="padding: 10px 0 10px 10px; margin: 10px 0 10px 0; padding-top: 5%">{{ user.name }}</td>
        </div>
      <div class="subsection">
        <button type="button" class="button--grey" @click="updateUser">Update</button>
        <button type="button" class="button--grey" @click="logoutUser">Logout</button>
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
        return { user: res.data }
      })
      .catch((e) => {
        error({ statusCode: 404, message: 'User not found' })
      })
  },
  head () {
    return {
      title: `User: ${this.user.username}`
    }
  },
  methods: {
    updateUser () {
      this.$nuxt.$router.replace({ path: `/users/${this.user.userid}/update` })
    },
    logoutUser () {
      this.$nuxt.$router.replace({ path: '../' })
    }
  }
}
</script>

<style lang="stylus" scoped>

.user-view
  background-image url("../../../assets/img/835617f07e419bb.jpg")
  height: 100%;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  position: absolute;
  width: 100%;
  opacity 30%
  overflow: hidden;
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
    font-size 24px
    font-weight 500
  .user-password
    font-size 24px
    font-weight 500
    color #707070
  a
    text-decoration underline
    &:hover
      color #515ec4

</style>
