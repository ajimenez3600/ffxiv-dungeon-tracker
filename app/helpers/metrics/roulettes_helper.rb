module Metrics::RoulettesHelper
  def table_data(where_options, selector, grouper = ->(e) { e.roulette.name }, sub_grouper = nil)
    entries = InstanceEntry.where(where_options).map do |data|
      { data: data, value: selector.call(data) }
    end
    levels.map do |level|
      { level: level, data: entries.keep_if { |e| e[:data].start_level == level} }
    end.each do |obj|
      obj[:data] = obj[:data].group_by { |e| grouper.call(e[:data]) }
      obj[:data].keys.each do |group|
        if !sub_grouper.nil? then
          obj[:data][group] = obj[:data][group].group_by { |e| sub_grouper.call(e[:data]) }
          obj[:data][group].keys.each do |sub_group|
            obj[:data][group][sub_group] = get_average(obj[:data][group][sub_group])
          end
        else
          obj[:data][group] = get_average(obj[:data][group])
        end
      end
    end
  end
  
  def get_average(values)
    return 0 unless values.count > 0
    values.map(&:value).sum / values.count
  end
  
  def chart_data(where_options, selector, x_grouper = ->(e) { e.roulette.name }, graph_grouper = -> (e) { 1 })
    entries = InstanceEntry.where(where_options).map do |data|
      { data: data, value: selector.call(data) }
    end
    graphs = entries.group_by { |e| graph_grouper.call(e[:data]) }
    graphs.keys.each do |graph|
      graphs[graph] = graphs[graph].group_by { |e| e[:data].roulette.name }
      graphs[graph].keys.each do |roulette|
        points = [ ]
        by_level = graphs[graph][roulette].group_by { |e| e[:data].start_level }
        by_level.keys.each do |level|
          by_level[level].group_by{ |e| selector.call(e[:data]) }.each do |group|
            points << { x: level, y: group.first, r: group.second.count }
          end
        end
        graphs[graph][roulette] = points
      end
    end
    graphs
  end

  def calculate_ordering(start_level, start_xp, roulettes)
    total_xp = Level.total_xp(start_level, start_xp)
    roulette_xp = roulettes.map do |roulette|      
      { roulette: roulette, name: roulette.name, xp: get_xp_for_roulette(roulette, start_level) }
    end

    xp_to_next = Level.total_xp(start_level + 1) * 1.03 # buffer xp to next by a bit
    return [ start_level => roulette_xp ] if roulette_xp.map { |r| r[:xp] }.sum < xp_to_next

    this_level = powerset!(roulette_xp)
      .map { |s| { data: s, sum: s.map(&:xp).sum } }
      .keep_if { |s| s.sum < xp_to_next }
      .sort_by { |s| sum }
      .first

    predicted_total_xp = total_xp + this_level.sum
    predicted_level = Level.get_level(predicted_total_xp)
    predicted_xp = predicted_total_xp - Level.total_xp(predicted_level)
    available_roulettes = roulettes - this_level.map(&:roulette)

    [ start_level => this_level ]
      + calculate_ordering(predicted_level, predicted_xp, available_roulettes)
  end

  def get_xp_for_roulette(roulette, start_level)
    entries = InstanceEntry.where(start_level: start_level, roulette: roulette)
    return 0 if entries.count == 0

    entries.sum { |e| e.bonus_xp + e.combat_xp } / entries.count
  end

  private

  def powerset!(set)
    return [set] if set.empty?

    p = set.pop
    subset = powerset!(set)
    subset | subset.map { |x| x | [p] }
  end
end
