<template>
  <div class="navbar">
    <a href="#">button1</a>
    <a href="#">button2</a>
    <div class="dropdown">
      <button class="dropbtn" onclick="myFunction()">Dropdown
        <i class="fa fa-caret-down"></i>
      </button>
      <div class="dropdown-content" id="myDropdown">
        <a href="#">select 1</a>
        <a href="#">Link 2</a>
        <a href="#">Link 3</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    doDropdown () {
      document.getElementById('myDropdown').classList.toggle('show')
    },
    closeDropDown () {
      window.onclick = function (e) {
        if (!e.target.matches('.dropbtn')) {
          let myDropdown = document.getElementById('myDropdown')
          if (myDropdown.classList.contains('show')) {
            myDropdown.classList.remove('show')
          }
        }
      }
    }
  }
}
</script>

<style lang="stylus" scoped>

  .navbar {
    overflow: hidden;
    background-color: #333;
    font-family: Arial;
  }

  .navbar a {
    float: left;
    font-size: 16px;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
  }

  .dropdown {
    float: left;
    overflow: hidden;
  }

  .dropdown .dropbtn {
    cursor: pointer;
    font-size: 16px;
    border: none;
    outline: none;
    color: white;
    padding: 14px 16px;
    background-color: inherit;
  }

  .navbar a:hover, .dropdown:hover .dropbtn {
    background-color: red;
  }

  .dropdown-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 160px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    z-index: 1;
  }

  .dropdown-content a {
    float: none;
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
    text-align: left;
  }

  .dropdown-content a:hover {
    background-color: #ddd;
  }

  .show {
    display: block;
  }
</style>
