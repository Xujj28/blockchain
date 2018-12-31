<template>
	<section id="info">
		<div class="form">
			<span class="label">序号：</span>
			<span class="content">{{info.index}}</span>
		</div>
		<div class="form">
			<span class="label">用户地址：</span>
			<span class="content">{{info.user}}</span>
		</div>
		<div class="form">
			<span class="label">订单名称：</span>
			<span class="content">{{info.name}}</span>
		</div>
		<div class="form">
			<span class="label">订单金额：</span>
			<span class="content">{{info.money}}</span>
		</div>
	</section>
</template>

<script>
	export default {
		name: 'info',
		props: ['info']
	}
</script>

<style lang="scss" scoped>
	#info {
		border: 1px solid #ccc;
		margin: 50px;
		text-align: left;
		background-color: #ccc;
		opacity: 0.8;

		.form {
			margin: 10px 5px;

			span {
				font-size: 16px;
			}	

			span.label {
				color: #000000;
			}

			span.content {
				color: #ffffff;
			}
		}
	}
</style>
