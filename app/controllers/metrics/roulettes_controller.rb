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
        level_group[roulette.name] = { raw: raw, average: raw.sum / raw.count }
      end
      @instance_groups << level_group
    end
  end
end
