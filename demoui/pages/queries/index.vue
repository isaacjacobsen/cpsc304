<template>
  <section class="queries-view">
    <div class="content">
      <div class="subsection">
        <ul style="list-style-type: none; padding: 0; margin: 0;">
          <li style="padding: 10px 20px; margin: 0 25px; position: relative;">#1</li>
        </ul>
      </div>
    </div>
  </section>
</template>

<script>

export default {
  head () {
    return {
      title: 'Users'
    }
  }
}
</script>

<style lang="stylus" scoped>
.queries-view
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
    font-size 26px
    font-weight 500
  .title
    font-size 18px
    font-weight 500
  a
    text-decoration underline
    &:hover
      color #515ec4

</style>