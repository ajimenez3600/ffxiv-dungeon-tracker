namespace :patch_update do
  desc "Fetches all data from xivapi"
  task fetch_xivapi_data: :environment do
    Rake::Task['patch_update:fetch_instances'].invoke
    Rake::Task['patch_update:fetch_jobs'].invoke
    Rake::Task['patch_update:fetch_xp_table'].invoke
  end

  desc "Fetches Instance listing from xivapi"
  task fetch_instances: :environment do
    rejected_instances = ['Seasonal Dungeon', 'Gold Saucer', 'The Masked Carnivale', 'Disciples of the Land']
    expansions = { 50 => 'ARR', 60 => 'HW', 70 => 'SB', 80 => 'ShB' }
    
    response = HTTParty.get('https://xivapi.com/InstanceContent?limit=1000&columns=ID,Name,ContentType.Name,ContentFinderCondition,BossExp1,BossExp2,BossExp3,BossExp4,FinalBossExp,InstanceClearExp,NewPlayerBonusA,NewPlayerBonusB')
    if response.code != 200 then
      puts response.code
      next
    end

    fetched_instances = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_instances.count} instances"
    fetched_instances.each do |fetched_instance|
      # drop some of the instance types from getting into the database
      next if fetched_instance['ContentType']['Name'].blank?
      next if rejected_instances.include?(fetched_instance['ContentType']['Name'])
      puts fetched_instance['Name']
      # organize the remaining ones by expansion
      next unless Instance.find_by_name(fetched_instance['Name']).nil?

      expansion = ''
      expansions.keys.each do |cap|
        next unless cap >= (fetched_instance['ContentFinderCondition']['ClassJobLevelSync'] || 999)
        expansion = expansions[cap]
        break
      end

      instance = Instance.new(
        name: fetched_instance['Name'],
        api_id: fetched_instance['ID'],
        instance_type: fetched_instance['ContentType']['Name'],
        required_level: fetched_instance['ContentFinderCondition']['ClassJobLevelRequired'],
        required_item_level: fetched_instance['ContentFinderCondition']['ItemLevelRequired'],
        level_sync: fetched_instance['ContentFinderCondition']['ClassJobLevelSync'],
        item_level_sync: fetched_instance['ContentFinderCondition']['ItemLevelSync'],
        expansion: expansion,

        alliance_roulette?: fetched_instance['ContentFinderCondition']['AllianceRoulette'],
        expert_roulette?: fetched_instance['ContentFinderCondition']['ExpertRoulette'],
        guild_hest_roulette?: fetched_instance['ContentFinderCondition']['GuildHestRoulette'],
        level_50_60_70_roulette?: fetched_instance['ContentFinderCondition']['Level50/60/70Roulette'],
        level_80_roulette?: fetched_instance['ContentFinderCondition']['Level80Roulette'],
        leveling_roulette?: fetched_instance['ContentFinderCondition']['LevelingRoulette'],
        msq_roulette?: fetched_instance['ContentFinderCondition']['MSQRoulette'],
        mentor_roulette?: fetched_instance['ContentFinderCondition']['MentorRoulette'],
        normal_raid_roulette?: fetched_instance['ContentFinderCondition']['NormalRaidRoulette'],
        trial_roulette?: fetched_instance['ContentFinderCondition']['TrialRoulette'],

        boss_1_exp: fetched_instance['BossExp1'],
        boss_2_exp: fetched_instance['BossExp2'],
        boss_3_exp: fetched_instance['BossExp3'],
        boss_4_exp: fetched_instance['BossExp4'],
        final_boss_exp: fetched_instance['FinalBossExp'],
        instance_clear_exp: fetched_instance['InstanceClearExp'],
        new_player_bonus_a: fetched_instance['NewPlayerBonusA'],
        new_player_bonus_b: fetched_instance['NewPlayerBonusB']
      )

      if instance.valid? then
        instance.save
      else
        puts "failed to save instance #{instance.name}", instance.errors
      end
    end
    puts 'instances imported'
  end

  desc "Fetches Job listing from xivapi"
  task fetch_jobs: :environment do
    response = HTTParty.get('https://xivapi.com/classjob?limit=1000&columns=NameEnglish_en,Abbreviation,CanQueueForDuty,ClassJobCategory.Name,Role')
    if response.code != 200 then
      puts response.code
      next
    end

    fetched_jobs = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_jobs.count} jobs"
    fetched_jobs.each do |fetched_job|
      next unless fetched_job['CanQueueForDuty'] == 1
      next unless Job.find_by_name(fetched_job['NameEnglish_en']).nil?

      job = Job.new(
        name: fetched_job['NameEnglish_en'],
        abbr: fetched_job['Abbreviation'],
        category: fetched_job['ClassJobCategory']['Name'],
        role: Role.find_by_api_id(fetched_job['Role'])
      )

      if job.valid? then
        job.save
      else
        puts job.errors
      end
    end
    puts 'jobs imported!'
  end

  desc "Fetches XP Table data from xivapi"
  task fetch_xp_table: :environment do
    response = HTTParty.get('https://xivapi.com/paramgrow?limit=1000&columns=ID,ExpToNext,ProperDungeon,ItemLevelSync')
    if response.code != 200 then
      puts response.code
      next
    end

    fetched_xp_data = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_xp_data.count} levels"
    fetched_xp_data.each do |xp_data|
      next unless Level.find_by_number(xp_data['ID']).nil?

      level = Level.new(
        number: xp_data['ID'],
        exp_to_next: xp_data['ExpToNext'],
        recommended_dungeon_id: xp_data['ProperDungeon'],
        item_level_sync: xp_data['ItemLevelSync']
      )

      if level.valid? then
        level.save
      else
        puts level.errors
      end
    end
    puts 'levels imported'
  end
end
