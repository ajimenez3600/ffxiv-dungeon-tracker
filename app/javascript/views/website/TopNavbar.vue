<template>
  <va-navbar color=primary shape class=mb-2>
    <template #left>
			<va-navbar-item>
				<router-link class='mx-2' to='/'>Form</router-link>
				<!-- <router-link class='mx-2' to='/metrics/roulette_calculator'>Roulette Calculator</router-link> -->
				<va-button-dropdown class='mx-2' disabled label="Roulette Metrics">
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
			<a class='mx-2' href="https://discord.com/users/158341423693955072">Discord</a>
			<a class='mx-2' href="https://github.com/blakexiaolong/ffxiv-dungeon-tracker">Github</a>
		</template>
	</va-navbar>
</template>