<template>
  <section id="home">
		<div class="option">
			<ul>
				<li :class="{'active': tabIndex === index}" @click="tabSwitch(index)" v-for="(item, index) in options">
					{{item}}
				</li>
			</ul>
		</div>
		<div class="content">
			<div class="contentOption" v-show="tabIndex == 0">
				<Info v-for="(item, index) in info" :info="item" @click="confirmTransaction"></Info>
			</div>
			<div class="contentOption" v-show="tabIndex == 1">
				<div class="form">
					<div class="entry">
						<input name="money" v-model="form.money" placeholder="请输入上交金额" type="number">
					</div>
					<div class="button">
						<button @click="handinMoney" name="handinMoney">提交</button>
						<button @click="cancelHandinMoney" name="cancelHandinMoney">取消</button>
					</div>
				</div>
			</div>
			<div class="contentOption" v-show="tabIndex == 2">
				<div class="form">
					<div class="entry">
						<input name="orderName" v-model="form.orderName" placeholder="请输入订单名称" type="text">
						<input name="orderMoney" v-model="form.orderMoney" placeholder="请输入订单金额" type="number">
					</div>
					<div class="button">
						<button @click="handinOrder" name="handinOrder">提交</button>
						<button @click="cancelHandinOrder" name="cancelHandinOrder">取消</button>
					</div>
				</div>
			</div>
			<div class="contentOption" v-show="tabIndex == 3">
				<div class="form">
					<div class="entry">
						<input name="address" v-model="form.address" placeholder="请输入用户地址" type="text">
					</div>
					<div class="button">
						<button @click="addUser" name="addUser">添加</button>
						<button @click="deleteUser" name="deleteUser">删除</button>
						<button @click="cancelUser" name="cancelUser">取消</button>
					</div>
				</div>
			</div>
		</div>
  </section>
</template>

<script>
	import Info from './Info';
	import users from '../js/users';

  export default {
		name: 'home',
		components: {
			Info
		},
		
    data() {
      return {
				id: undefined,
				user_or_manager: false,
				tabIndex: 0,
				options: ['订单确认', '上交费用', '提交订单'],
				form: {
					money: undefined,
					orderName: undefined,
					orderMoney: undefined,
					address: undefined
				},
				info: [
				]
      }
		},

		created: function() {
			//拿到用户id
			this.id = this.$route.params.id;

			this.user_or_manager = this.$route.params.administrator;

			users.init(this.id);

			if (this.user_or_manager == "true") {
				this.options.push('用户管理');
			}

		},
		
    methods: {
      tabSwitch: function(index) {
				this.tabIndex = index;
				if (index == 0) {
					this.getTransactions();
				}
			},

			handinMoney: function() {
				let self = this;

				let user = users.getCommitedUsers();
				user.then (commitedUsers => {
					var money = self.form.money;
					self.form.money = null;
					var isCommitedUser = false;
					for (var i = 0; i < 4; i++) {
						if (self.id == commitedUsers[i]) {
							isCommitedUser = true;
						}
					}
					if(isCommitedUser == true) {
						alert("你已经交费了，不用再交了");
					}
					else {
						if (money != 100) {
						money = null;
						alert("请输入正确的金额（100元）");
				}
				else {
					let user = users.getBalance();
					user.then(balance => {
					console.log(balance.valueOf());
					let user = users.commitFee();
					user.then(() => {
						alert("交费成功");
						let user = users.getBalance();
						user.then(balance => {
							console.log(balance.valueOf());
						})
					}).catch(e => {
						alert("交费失败, 请检查是否解锁账户以及余额是否充足");
						console.log(e);
					}) 
				})
				}
			}
		})	
			},

			cancelHandinMoney: function() {
				let self = this;

				self.form.money = null;
			},

			handinOrder: function() {
				let self = this;

				let user = users.commitTransaction(self.form.orderName, parseInt(self.form.orderMoney));
				user.then(length => {
					console.log(length.valueOf());
					let user = users.getBill();
					user.then(bill => {
						alert(bill.valueOf());
					})
				}).catch(e => {
					console.log(e);
				})
			},

			cancelHandinOrder: function() {
				let self = this;
				self.form.orderName = "";
				self.form.orderMoney = null;
			},

			addUser: function() {
				let self = this;
				if(this.form.address == undefined || this.form.address == "") {
					alert("请输入用户地址");
				}
				else {
					let user = users.getNumberOfUsers();

					user.then(num => {
						if (num == 4) {
							alert("用户已满，无法继续添加");
						}
						else {
							let user = users.getUsers();
							var isUser = false;
							user.then(Users => {
								for (var i = 0; i < 4; i++) {
									if (self.form.address == Users[i]) {
										isUser = true;
									}
								}
								if (isUser) {
									alert("该账号已经是用户了，无法继续添加");
								}
								else {
								let user = users.addUser(self.form.address);
								user.then(() => {
									alert("添加成功");
								}).catch(e => {
									console.log(e);
									alert("添加失败");
								})
							}
						})
						}
					})
				}
			},

			deleteUser: function() {
				let self = this;
				if (self.form.address == undefined || self.form.address == "") {
					alert("请输入用户地址");
				}
				else {
					let user = users.getUsers();
					var isUser = false;
					user.then(Users => {
						for (var i = 0; i < 4; i++) {
							if (self.form.address == Users[i]) {
								isUser = true;
							}
						}
						if (isUser == false) {
							alert("该账号还不是用户了，无法删除");
						}
						else {
							let user = users.deleteUser (self.form.address);
							user.then(() => {
								alert("删除成功");
							}).catch(e => {
								console.log(e);
								alert("删除失败");
							})
						}
					})
				}
			},

			cancelUser: function() {
				let self = this;
				self.form.address = "";
			},

			confirmTransaction: function() {
				console.log("confirmTransaction");
			},

			getTransactions: function() {
				let self = this;

				let user = users.getTotalNumberOfTransactions();
				user.then(num => {
					console.log(num.valueOf());
					for (var i = 0; i < num.valueOf(); i++) {
						let user = users.getTransaction(i);
						user.then(transaction => {
							if (transaction[1] != self.id) {
								self.info.push({
									index: transaction[0],
									user: transaction[1],
									name: transaction[2],
									money: transaction[3]
								})
							}
						}).catch(e => {
							console.log(e);
						})
					}
				}).catch(e => {
					console.log(e);
				})
			}

  }
}
</script>

<style lang="scss" scoped>
  #home {
    background: url('../assets/1.jpg') no-repeat;
    background-size: cover;
    height: 100%;
    display: flex;
    flex-direction: row;
    
    .option {
			width: 20%;
			height: 100%;
			border-right: 1px solid gray;

			ul {
				padding: 50px 0;
				list-style: none;

				li {
					color: #ffffff;
					height: 8%;
					line-height: 60px;
				}

				li:hover {
					color: #ff3030;
					cursor: pointer;
				}

				li.active {
					color: #ff3030;
				}
			}
		}

		.content {
			width: 80%;
			height: 100%;
			display: flex;
			justify-content: center;

			.contentOption {
				padding: 100px;
				width: 30%;

				.form {				
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
		}
  }

</style>
