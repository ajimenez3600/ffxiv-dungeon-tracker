# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.create([
  { api_id: 1, name: 'Tank' },
  { api_id: 2, name: 'Melee DPS' },
  { api_id: 3, name: 'Ranged DPS' },
  { api_id: 4, name: 'Healer' }
])

Roulette.create([
  { name: 'Leveling', grant_xp: true },
  { name: 'Trials', grant_xp: true },
  { name: '50/60/70', grant_xp: true },
  { name: 'Alliance Raid', grant_xp: true },
  { name: 'Normal Raid', grant_xp: true },
  { name: 'MSQ', grant_xp: true },
  { name: 'Guildhest', grant_xp: true },
  { name: 'Level 80', grant_xp: false },
  { name: 'Expert', grant_xp: false },
  { name: 'No Roulette', grant_xp: false }
])