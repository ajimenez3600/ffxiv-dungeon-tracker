namespace :patch_update do
  desc "Fetches all data from xivapi"
  task fetch_xivapi_data: :environment do
    Rake::Task['patch_update:fetch_expansions'].invoke
    Rake::Task['patch_update:fetch_instances'].invoke
    Rake::Task['patch_update:fetch_jobs'].invoke
    Rake::Task['patch_update:fetch_xp_table'].invoke
  end

  desc "Fetches Expansion listing from xivapi"
  task fetch_expansions: :environment do
    response = HTTParty.get('https://xivapi.com/exversion?limit=1000&columns=ID,Name')
    if response.code != 200 then
      puts "\t" + response.code
      next
    end

    fetched_expansions = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_expansions.count} expansions"

    fetched_expansions.each do |fetched_expansion|
      expansion = Expansion.find_by_name(fetched_expansion['Name'])
      if expansion.nil? then
        puts "\t" + fetched_expansion['Name']
        expansion = Expansion.new({ name: fetched_expansion['Name'] })
      end

      expansion.api_id = fetched_expansion['ID']
      if expansion.changed? then
        if expansion.valid? then
          expansion.save
        else
          puts "\t" + expansion.errors
        end
      end
    end
    puts "\texpansions imported!"
  end

  desc "Fetches Instance listing from xivapi"
  task fetch_instances: :environment do
    rejected_instances = ['Seasonal Dungeon', 'Gold Saucer', 'The Masked Carnivale', 'Disciples of the Land', 'Quest Battles']
    
    response = HTTParty.get('https://xivapi.com/InstanceContent?limit=1000&columns=ID,Name,ContentType.Name,ContentFinderCondition,BossExp1,BossExp2,BossExp3,BossExp4,FinalBossExp,InstanceClearExp,NewPlayerBonusA,NewPlayerBonusB')
    if response.code != 200 then
      puts "\t" + response.code
      next
    end

    fetched_instances = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_instances.count} instances"

    instance_names = fetched_instances.map { |i| i['Name'] }
    Instance.all.each { |i| i.delete unless instance_names.include?(i.name) }

    fetched_instances.each do |fetched_instance|
      # drop some of the instance types from getting into the database
      next if fetched_instance['ContentType']['Name'].blank?
      next if rejected_instances.include?(fetched_instance['ContentType']['Name'])

      instance = Instance.find_by_name(fetched_instance['Name'])
      if instance.nil? then
        puts "\t" + fetched_instance['Name']
        instance = Instance.new({name: fetched_instance['Name']})
      end

      instance.api_id = fetched_instance['ID']
      instance.instance_type = fetched_instance['ContentType']['Name']
      instance.required_level = fetched_instance['ContentFinderCondition']['ClassJobLevelRequired']
      instance.required_item_level = fetched_instance['ContentFinderCondition']['ItemLevelRequired']
      instance.level_sync = fetched_instance['ContentFinderCondition']['ClassJobLevelSync']
      instance.item_level_sync = fetched_instance['ContentFinderCondition']['ItemLevelSync']
      instance.expansion = Expansion.find_by_name(fetched_instance['ContentFinderCondition']['TerritoryType']['ExVersion']['Name'])

      instance.alliance_roulette = fetched_instance['ContentFinderCondition']['AllianceRoulette']
      instance.expert_roulette = fetched_instance['ContentFinderCondition']['ExpertRoulette']
      instance.guild_hest_roulette = fetched_instance['ContentFinderCondition']['GuildHestRoulette']
      instance.level_50_60_70_roulette = fetched_instance['ContentFinderCondition']['Level50/60/70Roulette']
      instance.level_80_roulette = fetched_instance['ContentFinderCondition']['Level80Roulette']
      instance.leveling_roulette = fetched_instance['ContentFinderCondition']['LevelingRoulette']
      instance.msq_roulette = fetched_instance['ContentFinderCondition']['MSQRoulette']
      instance.mentor_roulette = fetched_instance['ContentFinderCondition']['MentorRoulette']
      instance.normal_raid_roulette = fetched_instance['ContentFinderCondition']['NormalRaidRoulette']
      instance.trial_roulette = fetched_instance['ContentFinderCondition']['TrialRoulette']

      instance.boss_1_exp = fetched_instance['BossExp1']
      instance.boss_2_exp = fetched_instance['BossExp2']
      instance.boss_3_exp = fetched_instance['BossExp3']
      instance.boss_4_exp = fetched_instance['BossExp4']
      instance.final_boss_exp = fetched_instance['FinalBossExp']
      instance.instance_clear_exp = fetched_instance['InstanceClearExp']
      instance.new_player_bonus_a = fetched_instance['NewPlayerBonusA']
      instance.new_player_bonus_b = fetched_instance['NewPlayerBonusB']

      if instance.changed?
        if instance.valid? then
          instance.save
        else
          puts "\t failed to save instance #{instance.name}", instance.errors
        end
      end
    end
    puts "\t instances imported!"
  end

  desc "Fetches Job listing from xivapi"
  task fetch_jobs: :environment do
    response = HTTParty.get('https://xivapi.com/classjob?limit=1000&columns=NameEnglish_en,Abbreviation,CanQueueForDuty,ClassJobCategory.Name,Role')
    if response.code != 200 then
      puts  "\t" + response.code
      next
    end

    fetched_jobs = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_jobs.count} jobs"

    job_names = fetched_jobs.map { |job| job['NameEnglish_en'] }
    Job.all.each { |job| job.delete unless job_names.include?(job.name) }
    
    fetched_jobs.each do |fetched_job|
      next unless fetched_job['CanQueueForDuty'] == 1
      
      job = Job.find_by_name(fetched_job['NameEnglish_en'])
      if job.nil?
        job = Job.new(name: fetched_job['NameEnglish_en'])
      end

      job.abbr = fetched_job['Abbreviation']
      job.category = fetched_job['ClassJobCategory']['Name']
      job.role = Role.find_by_api_id(fetched_job['Role'])

      if job.changed? then
        if job.valid? then
          job.save
        else
          puts  "\t" + job.errors
        end
      end
    end
    puts "\t jobs imported!"
  end

  desc "Fetches XP Table data from xivapi"
  task fetch_xp_table: :environment do
    response = HTTParty.get('https://xivapi.com/paramgrow?limit=1000&columns=ID,ExpToNext,ProperDungeon,ItemLevelSync')
    if response.code != 200 then
      puts  "\t" + response.code
      next
    end

    fetched_xp_data = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_xp_data.count} levels"
    fetched_xp_data.each do |xp_data|
      level = Level.find_by_number(xp_data['ID'])
      if level.nil?
        level = Level.new(number: xp_data['ID'])
      end

      level.exp_to_next = xp_data['ExpToNext']
      level.recommended_dungeon_id = xp_data['ProperDungeon']
      level.item_level_sync = xp_data['ItemLevelSync']

      next if level.exp_to_next == 0

      if level.changed? then
        if level.valid? then
          level.save
        else
          puts  "\t" + level.errors
        end
      end
    end
    puts "\t levels imported!"

    levels = Level.all.sort_by(&:number)
    levels.each_with_index do |level, ix|
      if ix == 0 then
        level.total_xp = 0
      else
        level.total_xp = levels[ix-1].total_xp + levels[ix-1].exp_to_next
      end
      if level.changed? then
        if level.valid? then
          level.save
        else
          puts level.errors
        end
      end
    end
    puts "\t level data calculated!"
  end
end
