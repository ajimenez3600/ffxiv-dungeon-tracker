class Metrics::RoulettesController < ApplicationController
  def index
    levels = InstanceEntry.all.map(&:start_level).uniq
    roulettes = InstanceEntry.all.map{ |e| e.roulette }.uniq
    roulettes.delete(Roulette.find_by_name('No Roulette'))

    @roulette_names = roulettes.map(&:name)
    @instance_groups = [ ]
    levels.each do |level|
      level_group = { level: level }
      roulettes.each do |roulette|
        raw = InstanceEntry.where(start_level: level, roulette: roulette).map(&:roulette_bonus)
        average = 0
        average = raw.sum / raw.count if raw.count > 0
        level_group[roulette.name] = { raw: raw, average: average }
      end
      @instance_groups << level_group
      @instance_groups.sort_by { |g| g[:level] }
    end
  end
end
