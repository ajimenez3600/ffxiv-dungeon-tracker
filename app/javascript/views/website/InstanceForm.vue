<template>
<div>
	<va-alert :color="alert.color" v-model="alert.show" closeable>
		{{alert.message}}
	</va-alert>

  <va-form tag='form' @submit.prevent="handleSubmit">
		<section id="pre-instance">
			<h3>Pre-Instance</h3>
			<h5>Queue Start Time</h5>
			<div class=row>
				<div class='flex md12'>
					<va-date-picker v-model="form.startDate" />
					<va-time-picker v-model="form.startTime" />
				</div>
			</div>
			<div class=row>
				<div class='flex md12'>
					<va-select label='Roulette Name' v-model="form.rouletteName" :options=roulettes />
				</div>
			</div>
			<div class=row>
				<div class='flex md12'>
					<va-select label='Job Name (*)' v-model="form.jobName" :options=jobs />
				</div>
			</div>
			<div class=row>
				<div class='flex md6'>
					<va-input label='Starting Level (*)' v-model='form.startLevel' />
				</div>
				<div class='flex md6'>
					<va-input label='Starting XP (*)' v-model='form.startXp' />
					reimpl the xp adder
				</div>
			</div>
			<h5>Queue Pop Time</h5>
			<div class=row>
				<div class='flex md12'>
					<va-date-picker v-model="form.queueDate" />
					<va-time-picker v-model="form.queueTime" />
				</div>
			</div>
			<div class=row v-if=longQueue>
				<div class='flex md12'>
					It looks like you spent {{queueTime}} hours in queue, is that right?
				</div>
			</div>
			<div class=row v-if=negativeQueue>
				<div class='flex md12'>
					You seem to have been queued for a negative amount of time. Please take another look.
				</div>
			</div>
		</section>

		<section id='instance'>
			<h3>Instance(*)</h3>
		</section>

		<section id='post-instance'>
			<h3>Post-Instance</h3>
			<h5>Instance Finish Time</h5>
			<div class=row>
				<div class='flex md12'>
					<va-date-picker v-model="form.startDate" />
					<va-time-picker v-model="form.startTime" />
				</div>
			</div>
			<div class=row v-if=longInstance>
				<div class='flex md12'>
					It looks like you spent {{instanceTime}} hours in queue, is that right?
				</div>
			</div>
			<div class=row v-if=negativeInstance>
				<div class='flex md12'>
					You seem to have been queued for a negative amount of time. Please take another look.
				</div>
			</div>
			<div class=row>
				<div class='flex md6'>
					<va-input label='Finish Level (*)' v-model='form.finishLevel' />
				</div>
				<div class='flex md6'>
					<va-input label='Finish XP (*)' v-model='form.finishXp' />
				</div>
			</div>
		</section>
  </va-form>
</div>
</template>

<script>
import moment from 'moment';

export default {
	data() {
		return {
			alert: {
				color: 'primary',
				show: true,
				message: 'message',
			},
			form: {
				startDate: null,
				startTime: null,
			},
		};
	},
	methods: {
		setCurrentDateTime(field) {
			let dt = moment()
			switch(field) {
				case 'start':
					this.form.startDate = dt.format('YYYY-MM-DD');
					this.form.startTime = dt.format('HH:mm');
					break;
				case 'pop':
					break;
				case 'finish':
					break;
				default:
					break;
			}
		},
	}
}
</script>
