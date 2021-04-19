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
  { name: 'Leveling' },
  { name: 'Trials' },
  { name: '50/60/70' },
  { name: 'Alliance Raid' },
  { name: 'Normal Raid' },
  { name: 'MSQ' },
  { name: 'Guildhest' },
  { name: 'Level 80' },
  { name: 'Expert' },
  { name: 'No Roulette' }
])