class Metrics::RoulettesController < ApplicationController
  def index
    levels = InstanceEntry.all.map(&:start_level).uniq.sort
    roulettes = InstanceEntry.all.map{ |e| e.roulette }.uniq
    roulettes.delete(Roulette.find_by_name('No Roulette'))

    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    @table_data = [ ]
    levels.each do |level|
      level_group = { level: level }
      roulettes.each do |roulette|
        raw = InstanceEntry.where(start_level: level, roulette: roulette).map(&:roulette_bonus)
        average = 0
        average = raw.sum / raw.count if raw.count > 0
        level_group[roulette.name] = { raw: raw, average: average }
      end
      @table_data << level_group
    end

    @chart_data = { }
    roulettes.each do |roulette|
      roulette_group = [ ]
      by_level = InstanceEntry.where(roulette: roulette).group_by { |e| e[:start_level] }
      by_level.keys.each do |level|
        by_xp = by_level[level].group_by { |e| e[:roulette_bonus] }
        by_xp.map do |group|
          roulette_group << { x: level, y: group.second.first[:roulette_bonus], r: group.second.count }
        end
      end
      @chart_data[roulette.name] = roulette_group
    end
  end
end
