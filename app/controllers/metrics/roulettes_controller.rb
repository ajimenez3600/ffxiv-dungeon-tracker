class Metrics::RoulettesController < ApplicationController
  include Metrics::RoulettesHelper

  def roulette_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { xp_outlier: false }
    selector = ->(e) { e.roulette_bonus }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def instance_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { xp_outlier: false }
    selector = ->(e) { e.combat_xp }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def total_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { xp_outlier: false }
    selector = ->(e) { e.bonus_xp + e.combat_xp }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def instance_time
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { duration_outlier: false }
    selector = ->(e) { e.finish_time - e.queue_pop_time }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  # multi table?
	@@ -108,10 +54,6 @@ def roulette_efficiency

  private

  def levels
    @levels ||= InstanceEntry.all
      .map(&:start_level)
	@@ -121,39 +63,8 @@ def levels

  def roulettes
    @roulettes ||= InstanceEntry.all.to_a
      .keep_if { |e| !e.roulette.nil? and e.roulette.name != 'No Roulette' }
      .map { |e| e.roulette }
      .uniq
  end
end
