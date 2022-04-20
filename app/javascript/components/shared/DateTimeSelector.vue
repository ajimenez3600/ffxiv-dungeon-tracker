<template>
<div class='row my-2'>
	<div class='flex md6 pr-1'>
		<va-date-input v-model="dateInput" @update:model-value=onUpdateDate />
	</div>
	<div class='flex md6 pl-1'>
		<va-time-input v-model="timeInput" @update:model-value=onUpdateTime>
			<template #append>
				<va-button class="mx-2" @click='setCurrentDateTime'>Set Now</va-button>
			</template>
		</va-time-input>
	</div>
</div>
</template>

<script>
import moment from 'moment';

export default {
	emits: ['input'],
	props: {
		modelValue: {
			type: Date,
			required: true,
		},
	},
	data() {
		return {
			timeInput: new Date(),
			dateInput: new Date(),
		};
	},
	methods: {
		setCurrentDateTime() {
			this.timeInput = new Date();
			this.dateInput = this.timeInput;
			this.$emit('update:modelValue', this.dateInput)
		},
		onUpdateDate() {
			this.dateInput.setHours(this.timeInput.getHours())
			this.dateInput.setMinutes(this.timeInput.getMinutes())
			this.dateInput.setSeconds(this.timeInput.getSeconds())
			this.dateInput.setMilliseconds(this.timeInput.getMilliseconds())
			this.timeInput = this.dateInput;
			this.$emit('update:modelValue', this.dateInput)
		},
		onUpdateTime() {
			this.timeInput.setFullYear(this.dateInput.getFullYear())
			this.timeInput.setMonth(this.dateInput.getMonth())
			this.timeInput.setDate(this.dateInput.getDate())
			this.dateInput = this.timeInput;
			this.$emit('update:modelValue', this.timeInput)
		}
	},
};
</script>
