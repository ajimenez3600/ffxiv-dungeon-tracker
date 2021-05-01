namespace :database_fixes do
  desc "fix instance_entries to have proper defaults"
  task default_entries: :environment do
    InstanceEntry.all.each do |entry|
      entry.roulette_bonus ||= 0
      entry.role_in_need_bonus ||= 0
      entry.new_player_bonus ||= 0
      entry.other_bonus ||= 0
      entry.xp_bonus ||= 100

      entry.xp_outlier ||= false
      entry.queue_outlier ||= false
      entry.duration_outlier ||= false
      entry.commends ||= 0

      entry.save
    end
  end
end