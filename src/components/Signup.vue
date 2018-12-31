<template>
  <section id="signup">
    <div class="form">
      <h1>Sign up</h1>
      <div class="entry">
        <input name="address" v-model="form.address" placeholder="请输入用户地址" type="text">
        <input name="password" v-model="form.password" placeholder="请输入密码" type="password">
      </div>
      <div class="button">
        <button @click="isUser" name="signup">登录</button>
        <button @click="cancel" name="cancel">取消</button>
      </div>
    </div>
  </section>
</template>

<script>
  //import Users from '@/js/user
  import users from '../js/users'

  export default {
		name: 'signup',
		
    data() {
      return {
        form: {
          address: undefined,
          password: undefined
				},
				id: undefined,
        administrator: false
      }
		},
		
    /* beforeCreate: function() {
      Users.init()
		}, */

		created: function() {
			users.init();
		},
		
    methods: {
      signup: function() {
        this.$router.push('/home/' + this.id + '/' + this.administrator);
			},
			
      cancel: function() {
        this.id = "";
        this.form.address = "";
      },

      isUser: async function() {
        let self = this;
        self.id = self.form.address;
        if (self.id == undefined || self.id == "") {
          alert("Please input your address.");
        }
        else {
          let user = users.getUsers();
          user.then(Users => {
            var isUser = false;
            for (var i = 0; i < 4; i++) {
              if (Users[i] == self.id) {
                isUser = true;
                if (i == 0) {
                  self.administrator = true;
                }
              }
            }
            if (isUser) {
              self.signup();
            }
            else {
              alert("You are not the member of this dorm.")
            }
          })
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  #signup {
    background: url('../assets/1.jpg') no-repeat;
    background-size: cover;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    
    .form {
      width: 20%;
      display: flex;
      flex-direction: column;
      margin: auto;
      
      .entry {
        display: flex;
        flex-direction: column;
        justify-content: center;
        
        input {
          height: 30px;
          margin-top: 10px;
          margin-bottom: 10px;
        }
      }
    }

    .button {
      margin-top: 10px;
      display: flex;
      justify-content: space-between;

      button {
        width: 40%;
        height: 30px;
      }

			button:hover {
				cursor: pointer;
			}
    }
  }

</style>
