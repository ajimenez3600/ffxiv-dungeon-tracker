class Metrics::RoulettesController < ApplicationController
  def roulette_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    options = { xp_outlier: false }
    selector = ->(e) { e.roulette_bonus }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def instance_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    options = { xp_outlier: false }
    selector = ->(e) { e.combat_xp }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def total_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    options = { xp_outlier: false }
    selector = ->(e) { e.bonus_xp + e.combat_xp }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def instance_time
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{|r| { key: r.name, sortable: true } }

    options = { duration_outlier: false }
    selector = ->(e) { e.finish_time - e.queue_pop_time }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
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

  def table_data(where_options, selector, grouper = ->(e) { e.roulette.name }, sub_grouper = nil)
    entries = InstanceEntry.where(where_options).map do |entry|
      { entry: entry, value: selector.call(entry) }
    end
    levels_array = levels.map do |level|
      { level: level, entries: entries.keep_if { |e| e.entry.start_level == level} }
    end.each do |obj|
      obj.entries = obj.entries.group_by { |e| grouper.call(e.entry) }
      obj.entries.keys.each do |group|
        if !sub_grouper.nil? then
          obj.entries[group] = obj.entries[group].group_by { |e| sub_grouper.call(e.entry) }
          obj.entries[group].keys.each do |sub_group|
            obj.entries[group][sub_group] = get_average(obj.entries[group][sub_group])
          end
        else
          obj.entries[group] = get_average(obj.entries[group])
        end
      end
    end
  end

  def get_average(values)
    return 0 unless values.count > 0
    values.map(&:value).sum / values.count
  end

def chart_data(where_options, selector, x_grouper = ->(e) { e.roulette.name }, graph_grouper = -> (e) { 1 })
  entries = InstanceEntry.where(where_options).map do |entry|
    { entry: entry, value: selector.call(entry) }
  end
  graphs = entries.group_by { |e| graph_grouper.call(e.entry) }
  graphs.keys.each do |graph|
    graphs[graph] = graphs[graph].group_by { |e| e.entry.roulette.name }
    graphs[graph].keys.each do |roulette|
      points = [ ]
      by_level = graphs[graph][roulette].group_by { |e| e.entry.start_level }
      by_level.keys.each do |level|
        by_level[level].group_by{ |e| selector.call(e.entry) }.each do |group|
          points << { x: level, y: group.first, group.second.count }
        end
      end
      graphs[graph][roulette] = points
    end
  end
  graphs
end
