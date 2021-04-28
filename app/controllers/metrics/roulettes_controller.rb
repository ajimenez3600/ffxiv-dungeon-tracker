class Metrics::RoulettesController < ApplicationController
  def roulette_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    @table_data = [ ]
    levels.each do |level|
      level_group = { level: level }
      roulettes.each do |roulette|
        raw = entries.where(xp_outlier: false).map(&:roulette_bonus)
        average = 0
        average = raw.sum / raw.count if raw.count > 0
        level_group[roulette.name] = { raw: raw, average: average }
      end
      @table_data << level_group
    end

    @chart_data = { }
    roulettes.each do |roulette|
      roulette_group = [ ]
      by_level = entries.where(xp_outlier: false).group_by { |e| e[:start_level] }
      by_level.keys.each do |level|
        by_xp = by_level[level].group_by(&:roulette_bonus)
        by_xp.map do |group|
          roulette_group << { x: level, y: group.second.first[:roulette_bonus], r: group.second.count }
        end
      end
      @chart_data[roulette.name] = roulette_group
    end
  end

  def instance_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    @table_data = [ ]
    levels.each do |level|
      level_group = { level: level }
      roulettes.each do |roulette|
        raw = entries.where(xp_outlier: false).map(&:combat_xp)
        average = 0
        average = raw.sum / raw.count if raw.count > 0
        level_group[roulette.name] = { raw: raw, average: average }
      end
      @table_data << level_group
    end

    @chart_data = { }
    roulettes.each do |roulette|
      roulette_group = [ ]
      by_level = entries.where(xp_outlier: false).group_by { |e| e[:start_level] }
      by_level.keys.each do |level|
        by_xp = by_level[level].group_by(&:combat_xp)
        by_xp.map do |group|
          roulette_group << { x: level, y: group.second.first[:roulette_bonus], r: group.second.count }
        end
      end
      @chart_data[roulette.name] = roulette_group
    end
  end

  def total_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    # @table_data = [ ]
    # levels.each do |level|
    #   level_group = { level: level }
    #   roulettes.each do |roulette|
    #     raw = entries.where(xp_outlier: false).map{ |e| e.bonus_xp + e.combat_xp }
    #     average = 0
    #     average = raw.sum / raw.count if raw.count > 0
    #     level_group[roulette.name] = { raw: raw, average: average }
    #   end
    #   @table_data << level_group
    # end
    @table_data = table_data({ xp_outlier: false }, ->(e) { e.bonus_xp + e.combat_xp })

    # @chart_data = { }
    # roulettes.each do |roulette|
    #   roulette_group = [ ]
    #   by_level = entries.where(xp_outlier: false).group_by { |e| e[:start_level] }
    #   by_level.keys.each do |level|
    #     by_xp = by_level[level].group_by{ |e| e.bonus_xp + e.combat_xp }
    #     by_xp.map do |group|
    #       roulette_group << { x: level, y: group.second.first[:roulette_bonus], r: group.second.count }
    #     end
    #   end
    #   @chart_data[roulette.name] = roulette_group
    # end

    #@chart_data = chart_data({ xp_outlier: false }, ->(e) { e.start_level }, ->(e) { e.bonus_xp + e.combat_xp })
  end

  def instance_time
  end

  # multi table?
  # https://jsfiddle.net/TLAV8/
  def queue_time
  end

  def total_time
  end

  def roulette_efficiency
  end

  private

  def entries(level, roulette)
    InstanceEntry.where(start_level: level, roulette: roulette)
  end

  def levels
    @levels ||= InstanceEntry.all
      .map(&:start_level)
      .uniq
      .sort
  end

  def roulettes
    @roulettes ||= InstanceEntry.all.to_a
      .keep_if { |e| e.roulette.name != 'No Roulette' }
      .map{ |e| e.roulette }
      .uniq
  end

  def table_data(where_options, &selector)
    table_data = [ ]
    levels.each do |level|
      level_group = { level: level }
      roulettes.each do |roulette|
        raw = entries.where(where_options).map{ |e| selector.call(e) }
        average = 0
        average = raw.sum / raw.count if raw.count > 0
        level_group[roulette.name] = { raw: raw, average: average }
      end
      table_data << level_group
    end
    table_data
  end

  # def chart_data(where_options, &grouper, &selector)
  #   chart_data = { }
  #   roulettes.each do |roulette|
  #     roulette_group = [ ]
  #     by_level = entries.where(where_options).group_by { |e| grouper.call(e) }
  #     by_level.keys.each do |level|
  #       by_xp = by_level[level].group_by{ |e| selector.call(e) }
  #       by_xp.map do |group|
  #         roulette_group << { x: level, y: group.first, r: group.second.count }
  #       end
  #     end
  #     chart_data[roulette.name] = roulette_group
  #   end
  #   chart_data
  # end
end
