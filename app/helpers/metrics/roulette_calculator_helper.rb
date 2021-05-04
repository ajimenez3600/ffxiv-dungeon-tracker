module Metrics::RouletteCalculatorHelper
  def calculate_ordering(start_level, start_xp, roulettes)
    if roulettes.count == 0 then
      return {
        start_level: start_level,
        estimated_level: start_level,
        estimated_xp: start_xp
      }
    end

    total_xp = Level.total_xp(start_level, start_xp)
    roulette_xp = roulettes.map do |roulette|
      {
        roulette: roulette,
        name: roulette.name,
        predicted_xp: get_xp_for_roulette(roulette, start_level),
        next_level_xp: get_xp_for_roulette(roulette, start_level + 1)
      }
    end

    xp_to_next = (Level.total_xp(start_level + 1) * 1.03).to_i - total_xp # buffer xp to next by a bit
    puts "xp to next: #{xp_to_next} | predicted xp: #{roulette_xp.map { |r| r[:predicted_xp] }.sum}"

    if roulette_xp.map { |r| r[:predicted_xp] }.sum > xp_to_next then
      sets = powerset!(roulette_xp.dup).keep_if { |s| s.map { |r| r[:predicted_xp] }.sum > xp_to_next }
      best_set = sets.sort_by do |set|
        roulette_xp.reject do |roulette|
          set.map { |s| s[:name] }.include?(roulette[:name])
        end.map { |roulette| roulette[:next_level_xp] }.sum
      end.reverse.first

      estimated_total_xp = total_xp + best_set.map { |r| r[:predicted_xp] }.sum
      estimated_level = Level.get_level(estimated_total_xp)
      estimated_xp = estimated_total_xp - Level.total_xp(estimated_level)
      remaining_roulettes = roulettes - best_set.map { |r| r[:roulette] }

      lower_ordering = calculate_ordering(estimated_level, estimated_xp, remaining_roulettes)
      return {
        start_level => scrub_db_info(best_set),
        estimated_level: estimated_level,
        estimated_xp: estimated_xp
      }.merge(scrub_toplevel_fields(lower_ordering))
    else
      estimated_total_xp = total_xp + roulette_xp.map { |r| r[:predicted_xp] }.sum
      estimated_level = Level.get_level(estimated_total_xp)
      estimated_xp = estimated_total_xp - Level.total_xp(estimated_level)

      return {
        start_level => scrub_db_info(roulette_xp),
        estimated_level: estimated_level,
        estimated_xp: estimated_xp
      }
    end
  end

  def get_xp_for_roulette(roulette, start_level)
    entries = InstanceEntry.where(start_level: start_level, roulette: roulette, xp_outlier: false)
    return 0 if entries.count == 0

    entries.sum { |e| e.bonus_xp + e.combat_xp } / entries.count
  end

  private

  def scrub_toplevel_fields(ordering)
    ordering.except(:estimated_level, :estimated_xp)
  end

  def scrub_db_info(roulette_xp)
    roulette_xp.each { |r| r.except!(:roulette) }
  end

  def powerset!(set)
    return [set] if set.empty?

    p = set.pop
    subset = powerset!(set)
    subset | subset.map { |x| x | [p] }
  end
end