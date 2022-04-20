<template>
<div class=px-4>
	<va-alert :color="alert.variant" v-model="alert.show" closeable>
		{{alert.message}}
	</va-alert>

  <va-form tag='form' @submit.prevent="onSubmit">
		<section id="pre-instance">
			<h5>Queue Start Time</h5>
			<date-time-selector v-if='form.startTime' v-model='form.startTime' />
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
				<div class='flex md6 pr-1'>
					<va-input label='Starting Level (*)' v-model='form.startLevel' />
				</div>
				<div class='flex md6 pl-1'>
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
			<date-time-selector v-if='form.queueTime' v-model='form.queueTime' @update:model-value=updateTimes />
			<va-alert color=warning v-if="queueDuration > 120">
				It looks like you spent {{Math.round(queueTime/60)}} hours in queue, is that right?
			</va-alert>
			<va-alert color=danger v-if="queueDuration < 0">
				You seem to have been queued for a negative amount of time. Please take another look.
			</va-alert>
		</section>

		<section id='instance'>
			<hr />
			<div>
				<va-card v-for="key in Object.keys(instances)" :key=key class='my-1'>
					<va-card-title class='pb-0 pt-1 px-1'>
						{{key}}
					</va-card-title>
					<va-card-content class='pt-0 pb-2'>
						<div class="row justify--center">
							<better-collapse v-if="instances[key] instanceof Array" :header="key" :value="form.instanceName" :options="instances[key]" class="flex lg10 px-2" @updated="onRadioSelect" />
							<better-collapse v-else v-for="key2 in Object.keys(instances[key])" :key=key2 :header="key2" :value="form.instanceName" :options="instances[key][key2]" class="flex lg2 px-2" @updated="onRadioSelect" />
						</div>
					</va-card-content>
				</va-card>
			</div>
		</section>

		<section id='post-instance'>
			<hr />
			<h5>Instance Finish Time</h5>
			<date-time-selector v-if=form.finishTime v-model='form.finishTime' @update:model-value=updateTimes />
			<va-alert color=warning v-if="instanceDuration > 120">
				It looks like you spent {{Math.round(instanceDuration/60)}} hours in queue, is that right?
			</va-alert>
			<va-alert color=danger v-if="instanceDuration < 0">
				You seem to have been queued for a negative amount of time. Please take another look.
			</va-alert>
			<div class='row my-2'>
				<div class='flex md6 pr-1'>
					<va-input label='Finish Level (*)' v-model='form.finishLevel' />
				</div>
				<div class='flex md6 pl-1'>
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
		<div class='row my-2 justify--center' v-if="!!isValid">
			<div class='flex'>
				<va-button @click='goAgain=false' class='mx-1' type=submit>Submit</va-button>
				<va-button @click='goAgain=true' class='mx-1' type=submit>Submit & Go Again</va-button>
			</div>
		</div>
  </va-form>

	<va-modal ref=modal stateful>
		<template #message>
			{{xpAdder}}
			<div class='row my-2' v-for="(item,ix) in xpAdder" :key=ix >
				<va-input v-model=xpAdder[ix] />
			</div>
			<div class='row my-2'>
				<va-button @click=onAddXpRow />
			</div>
			<va-button @click=onXpOk class='mx-1' variant=primary>Add</va-button>
			<va-button @click="showXpAdder=false" class='mx-1' variant=secondary>Cancel</va-button>
		</template>
	</va-modal>
</div>
</template>

<script>
import axios from 'axios';
import moment from 'moment';
import BetterCollapse from '@/components/shared/BetterCollapse.vue';
import DateTimeSelector from '@/components/shared/DateTimeSelector.vue';

export default {
	components: {
		BetterCollapse,
		DateTimeSelector,
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
			queueDuration: 0,
			instanceDuration: 0,
			form: { },
			goAgain: false,
			showXpAdder: false,
			xpAdder: [],
		};
	},
	mounted() {
		this.resetForm();
		this.fetchData();
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
			return end_parsed.diff(start_parsed, 'minutes');
		},
		updateTimes() {
			this.queueDuration = this.getTimeDifference(this.form.startTime, this.form.queueTime);
			this.instanceDuration = this.getTimeDifference(this.form.queueTime, this.form.finishTime);
		},
		onXpShow() {
			this.xpAdder = [ ];
			this.onAddXpRow();
			console.log('hey', this.xpAdder);
			this.$refs.modal.show()
		},
		onAddXpRow() {
			this.xpAdder.push({ amount: 0 });
			console.log('hey', this.xpAdder);
		},
		onDeleteXpRow(ix) {
			this.xpAdder.splice(ix, 1);
		},
		onXpOk() {
			let total = this.xpAdder.map(x => x.amount).reduce((memo, x) => {
				return Number(memo) + Number(x);
			});
			this.form.startXp = Number(this.form.startXp) + total;
			this.showXpAdder = false;
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
