<template>
  <va-navbar color=primary shape>
    <template #left>
			<va-navbar-item>
				<router-link to='/'>Form</router-link>
			</va-navbar-item>
			<!-- <va-navbar-item>
				<router-link to='/metrics/roulette_calculator'>Roulette Calculator</router-link>
			</va-navbar-item> -->
			<va-navbar-item>
				<va-button-dropdown disabled label="Roulette Metrics">
					<router-link to='/metrics/roulettes/total_xp'>Roulette Total XP</router-link>
					<router-link to='/metrics/roulettes/roulette_xp'>Roulette Bonus XP</router-link>
					<router-link to="/metrics/roulettes/instance_xp">Roulette Instance XP</router-link>
					<router-link to="/metrics/roulettes/instance_time">Roulette Instance Time</router-link>
					<router-link to="/metrics/roulettes/queue_time">Roulette Queue Time</router-link>
					<router-link to="/metrics/roulettes/total_time">Roulette Total Time</router-link>
					<router-link to="/metrics/roulettes/roulette_efficiency">Roulette Efficiency</router-link>
				</va-button-dropdown>
			</va-navbar-item>
		</template>
		<template #right>
				<va-navbar-item>
					<a href="https://discord.com/users/158341423693955072">Discord</a>
				</va-navbar-item>
				<va-navbar-item>
					<a href="https://github.com/blakexiaolong/ffxiv-dungeon-tracker">Github</a>
				</va-navbar-item>
		</template>
	</va-navbar>
</template>

<style scoped>
.va-navbar__item a {
	color: gainsboro;
}
</style>
