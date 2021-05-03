module Metrics::RoulettesHelper
  def table_data(where_options, selector, grouper = ->(e) { e.roulette.name }, sub_grouper = nil)
    entries = InstanceEntry.where(where_options).map do |data|
      { data: data, value: selector.call(data) }
    end
    levels.map do |level|
      { level: level, data: entries.select { |e| e[:data].start_level == level} }
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

  def chart_data(where_options, selector, x_grouper = ->(e) { e.roulette }, graph_grouper = -> (e) { 1 })
    entries = InstanceEntry.where(where_options).map do |data|
      { data: data, value: selector.call(data) }
    end
    graphs = entries.group_by { |e| graph_grouper.call(e[:data]) }
    graphs.keys.each do |graph|
      graphs[graph] = graphs[graph].group_by { |e| x_grouper.call(e[:data]) }
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

  def get_average(values)
    return 0 unless values.count > 0
    values.map { |e| e[:value] }.sum / values.count
  end

  def levels
    @levels ||= InstanceEntry.all
      .map(&:start_level)
      .uniq
      .sort
  end
end