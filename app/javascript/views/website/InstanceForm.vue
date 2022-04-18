<template>
<div class=px-4>
	<va-alert :color="alert.variant" v-model="alert.show" closeable>
		{{alert.message}}
	</va-alert>

  <va-form tag='form' @submit.prevent="onSubmit">
		<section id="pre-instance">
			<h5>Queue Start Time</h5>
			<div class='row my-2'>
				<div class='flex md6 px-1'>
					<va-date-input v-model="form.startTime" />
				</div>
				<div class='flex md6 px-1'>
					<va-time-input v-model="form.startTime">
						<template #append>
							<va-button @click='setCurrentDateTime("start")'>Set Now</va-button>
						</template>
					</va-time-input>
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-select label='Roulette Name' v-model="form.rouletteName" :options=roulettes />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-select label='Job Name (*)' v-model="form.jobName" :options=jobs />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md6'>
					<va-input label='Starting Level (*)' v-model='form.startLevel' />
				</div>
				<div class='flex md6'>
					<va-input label='Starting XP (*)' v-model='form.startXp'>
						<template #append>
							<va-button @click="onXpShow">
                <i class="fa fa-plus" aria-hidden="true"></i>
							</va-button>
						</template>
					</va-input>
				</div>
			</div>
			<h5>Queue Pop Time</h5>
			<div class='row my-2'>
				<div class='flex md6 px-1'>
					<va-date-input v-model="form.queueTime" />
				</div>
				<div class='flex md6 px-1'>
					<va-time-input v-model="form.queueTime">
						<template #append>
							<va-button @click='setCurrentDateTime("queue")'>Set Now</va-button>
						</template>
					</va-time-input>
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
			<hr />
			<div>
				<va-card v-for="key in Object.keys(instances)" :key=key>
					<va-card-title>
						{{key}}
					</va-card-title>
					<va-card-content>
						<div class="row justify--center">
							<better-collapse v-if="instances[key] instanceof Array" :header="key" :value="form.instanceName" :options="instances[key]" class="flex lg10" @updated="onRadioSelect" />
							<better-collapse v-else v-for="key2 in Object.keys(instances[key])" :header="key2" :value="form.instanceName" :options="instances[key][key2]" class="flex lg2" @updated="onRadioSelect" />
						</div>
					</va-card-content>
				</va-card>
			</div>
		</section>

		<section id='post-instance'>
			<hr />
			<h5>Instance Finish Time</h5>
			<div class='row my-2'>
				<div class='flex md6 px-1'>
					<va-date-input v-model="form.finishTime" />
				</div>
				<div class='flex md6 px-1'>
					<va-time-input v-model="form.finishTime">
						<template #append>
							<va-button @click='setCurrentDateTime("finish")'>Set Now</va-button>
						</template>
					</va-time-input>
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
			<div class='row my-2'>
				<div class='flex md6'>
					<va-input label='Finish Level (*)' v-model='form.finishLevel' />
				</div>
				<div class='flex md6'>
					<va-input label='Finish XP (*)' v-model='form.finishXp' />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-input label="XP Bonus %" v-model='form.xpBonus' />
				</div>
			</div>
			<div class='row my-2' v-if="!!form.rouletteName">
				<div class='flex md12'>
					<va-input label="Roulette Bonus XP" v-model='form.rouletteBonus' />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-input label="New Player Bonus XP" v-model='form.newPlayerBonus' />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-input label="Role In Need Bonus XP" v-model='form.roleInNeedBonus' />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-input label="Other Bonus XP" v-model='form.otherBonus' />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-input label="Commends Recieved" v-model='form.commends' />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-checkbox class=mt-4 v-model='form.queueOutlier' label='Are you queueing with someone?' />
					<va-checkbox class=mt-4 v-model='form.durationOutlier' label='Did you join an in-progress group?' />
					<va-checkbox class=mt-4 v-model='form.xpOutlier' label='Did you hit level cap (or were at level cap before starting)?' />
				</div>
			</div>
			<div class='row my-2'>
				<div class='flex md12'>
					<va-input type=textarea label="Notes" class='mt-4' v-model='form.notes' />
				</div>
			</div>
		</section>
		<div class='row my-2' v-if="!!isValid">
			<div class='flex md2' />
			<div class='flex md10'>
				<va-button @click='goAgain=false' type=submit>Submit</va-button>
				<va-button @click='goAgain=true' type=submit>Submit & Go Again</va-button>
			</div>
		</div>
  </va-form>
</div>
</template>

<script>
import axios from 'axios';
import moment from 'moment';
import BetterCollapse from '@/components/shared/BetterCollapse.vue';

export default {
	components: {
		BetterCollapse,
	},
	data() {
		return {
			instances: { },
			jobs: [],
			roulettes: [],
			csrf: { },
			alert: {
				show: false,
			},
			form: { },
			goAgain: false,
			showXpPopover: false,
			xpAdder: [],
		};
	},
	mounted() {
		this.resetForm();
		this.fetchData();
	},
	computed: {
		longQueue() {
			return this.getTimeDifference(this.form.startTime, this.form.queueTime) > 2;
		},
		negativeQueue() {
			return this.getTimeDifference(this.form.startTime, this.form.queueTime) < 0;
		},
		longInstance() {
			return this.getTimeDifference(this.form.queueTime, this.form.finishTime) > 2;
		},
		negativeInstance() {
			return this.getTimeDifference(this.form.queueTime, this.form.finishTime) < 0;
		},
	},
	methods: {
		fetchData() {
			axios.get('/api/instances').then((response) => this.instances = response.data);
			axios.get('/api/jobs').then((response) => this.jobs = response.data);
			axios.get('/api/roulettes').then((response) => this.roulettes = response.data);
		},
		resetForm() {
			this.form = {
				startTime: new Date(),
				rouletteName: undefined,
				jobName: this.goAgain ? this.form.jobName : undefined,
				startLevel: this.goAgain ? this.form.finishLevel : undefined,
				startXp: this.goAgain ? this.form.finishXp : undefined,
				queueTime: new Date(),
				instanceName: "",
				finishTime: new Date(),
				finishLevel: undefined,
				finishXp: undefined,
				xpBonus: undefined,
				rouletteBonus: undefined,
				newPlayerBonus: undefined,
				roleInNeedBonus: undefined,
				otherBonus: undefined,
				commends: undefined,
				notes: undefined,
				queueOutlier: false,
				durationOutler: false,
				xpOutlier: false,
			};
		},
		getTimeDifference(start, end) {
			if (!start || !end) return false;

			let start_parsed = moment(start, 'YYYY-MM-DDTHH:mm')
			let end_parsed = moment(end, 'TTTT-MM-DDTHH:mm')
			return end_parsed.diff(start_parsed, 'hours');
		},
		setCurrentDateTime(field) {
			let dt = moment()
			switch(field) {
				case 'start':
					this.form.startTime = new Date();
					break;
				case 'pop':
					this.form.queueTime = new Date();
					break;
				case 'finish':
					this.form.finishTime = new Date();
					break;
				default:
					break;
			}
		},
		onXpShow() {
			this.xpAdder = [ ];
			this.onAddXpRow();
		},
		onAddXpRow() {
			this.xpAdder.push({ amount: 0 });
		},
		onDeleteXpRow(ix) {
			this.xpAdder.splice(ix, 1);
		},
		onXpOk() {
			let total = this.xpAdder.map(x => x.amount).reduce((memo, x) => {
				return Number(memo) + Number(x);
			});
			this.form.startXp = Number(this.form.startXp) + total;
			this.showXpPopover = false;
		},
		isValid() {
			return true;
		},
		onRadioSelect(event) {
			this.form.instanceName = event;
		},
		onSubmit(event) {
			event.preventDefault();

			if (!this.form.rouletteName) {
				this.form.rouletteBonus = 0;
			}
			this.form.utf8 = '✓';
      this.form.authenticity_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

			axios({
				method: 'POST',
				url: '/api/instance_entries',
				headers: {
					'Content-Type': 'application/json',
					'X-Requested-With': 'XMLHttpRequest',
				},
				data: {
					utf8: '✓',
					authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content'),

					start_time: this.form.startTime,
					roulette_name: this.form.rouletteName,
					job_name: this.form.jobName,
					start_level: this.form.startLevel,
					start_xp: this.form.startXp,
					queue_pop_time: this.form.queueTime,
					instance_name: this.form.instanceName,
					finish_time: this.form.finishTime,
					finish_level: this.form.finishLevel,
					finish_xp: this.form.finishXp,
					xp_bonus: this.form.xpBonus,
					roulette_bonus: this.form.rouletteBonus,
					new_player_bonus: this.form.newPlayerBonus,
					role_in_need_bonus: this.form.roleInNeedBonus,
					other_bonus: this.form.otherBonus,
					commends: this.form.commends,
					notes: this.form.notes,
					queue_outlier: this.form.queueOutlier,
					duration_outlier: this.form.durationOutlier,
					xp_outlier: this.form.xpOutlier,
				},
			}).then(() => {
				this.resetForm();
				window.scrollTo(0,0);
				this.showSuccess();
			}).catch(error => {
				console.error(error);
				this.showError(error);
			});
		},
		showSuccess() {
			this.alert = {
				variant: 'success',
				show: true,
				message: 'Data Submitted; Thank you!',
			},
			setTimeout(() => this.alert.show = false, 5000);
		},
		showError() {
			this.alert = {
				variant: 'danger',
				show: true,
				message: 'Something messed, up, details have been logged to the console, but if the error persists, please contact me!',
			};
		},
	}
}
</script>
