<template>
	<va-collapse :header=header v-model=expanded>
		<ul>
			<li v-for="(option, index) in options">
				<va-radio :key=index :option=option v-model=value @update:model-value="onSelect" />
			</li>
		</ul>
	</va-collapse>
</template>

<script>
export default {
	emits: ['updated'],
	props: {
		header: {
			required: true,
			type: String,
		},
		options: {
			type: Array,
			default: () => [],
		},
		value: {
			type: String,
			required: true,
		},
	},
	data() {
		return {
			expanded: false,
		};
	},
	methods: {
		onSelect() {
			this.$emit('updated', this.value);
		},
	},
};
</script>
