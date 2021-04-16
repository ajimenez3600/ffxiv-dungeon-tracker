namespace :patch_update do
  desc "Fetches Job listing from xivapi"
  task fetch_jobs: :environment do
    response = HTTParty.get('https://xivapi.com/classjob')
    if response.code != 200 then
      puts response.code
      next
    end

    fetched_jobs = JSON.parse(response.body)['Results']
    puts "fetched #{fetched_jobs} jobs"
    fetched_jobs.each do |fetched_job|
      next unless Job.find_by_name(fetched_job['Name']).nil?

      job_response = HTTParty.get("https://xivapi.com/classjob/#{fetched_job['ID']}")
      if job_response.code != 200 then
        puts job_response.code
        next
      end

      job_data = JSON.parse(job_response.body)
      next unless job_data['CanQueueForDuty'] == 1

      job = Job.new(
        name: job_data['NameInstance_en'],
        abbr: job_data['Abbreviation'],
        category: job_data['ClassJobCategory']['Name'],
        role: job_data['Role']
      )

      if job.valid? then
        job.save
      else
        puts job.errors
      end
    end
    puts 'jobs imported!'
  end

  # get role https://xivapi.com/role
  # get levels https://xivapi.com/level
  # get instances https://xivapi.com/instancecontent

  desc "Fetches Instance listing from GarlandTools"
  task fetch_instances: :environment do
    rejected_instances = ['Seasonal Dungeon', 'Gold Saucer', 'The Masked Carnivale', 'Disciples of the Land']
    expansions = { 50 => 'ARR', 60 => 'HW', 70 => 'SB', 80 => 'ShB' }
    response = HTTParty.get('https://www.garlandtools.org/db/doc/browse/en/2/instance.json')
    if response.code != 200 then
      puts response.code
      next
    end

    fetched_instances = JSON.parse(response.body)['browse']
    puts "fetched #{fetched_instances.count} instances"
    fetched_instances.each do |fetched_instance|
      # drop some of the instance types from getting into the database
      # organize the remaining ones by expansion
      next if rejected_instances.include?(fetched_instance['t'])
      puts fetched_instance['n']
      next unless Instance.find_by_name(fetched_instance['n']).nil?

      expansion = ''
      expansions.keys.each do |cap|
        next unless cap >= (fetched_instance['max_lvl'] || 999)
        expansion = expansions[cap]
        break
      end

      instance = Instance.new(name: fetched_instance['n'], instance_type: fetched_instance['t'].singularize, expansion: expansion)
      instance.min_level = fetched_instance['min_lvl'] if fetched_instance['min_lvl'].present?
      instance.max_level = fetched_instance['max_lvl'] if fetched_instance['max_lvl'].present?
      instance.min_ilvl = fetched_instance['min_ilvl'] if fetched_instance['min_ilvl'].present?
      instance.max_ilvl = fetched_instance['max_ilvl'] if fetched_instance['max_ilvl'].present?

      if instance.valid? then
        instance.save
      else
        puts instance.errors
      end
    end
    puts 'instances imported!'
  end
end
