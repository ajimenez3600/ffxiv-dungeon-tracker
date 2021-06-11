class Metrics::RoulettesController < ApplicationController
  include Metrics::RoulettesHelper

  def roulette_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { xp_outlier: false, roulette_id: Roulette.where(grant_xp: true).pluck(:id) }
    selector = ->(e) { e.roulette_bonus }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def instance_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { xp_outlier: false, roulette_id: Roulette.where(grant_xp: true).pluck(:id) }
    selector = ->(e) { e.combat_xp }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def total_xp
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { xp_outlier: false, roulette_id: Roulette.where(grant_xp: true).pluck(:id) }
    selector = ->(e) { e.combat_and_bonus_xp }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  def instance_time
    @columns = [{ key: 'level', sortable: true }]
    @columns += roulettes.map{ |r| { key: r.name, sortable: true } }

    options = { duration_outlier: false, roulette_id: Roulette.all.pluck(:id) }
    selector = ->(e) { e.minutes_in_instance }
    @table_data = table_data(options, selector)
    @chart_data = chart_data(options, selector)
  end

  # multi table?
  # https://jsfiddle.net/TLAV8/
  def queue_time
    options = { duration_outlier: false, roulette_id: Roulette.all.pluck(:id) }
    selector = ->(e) { e.minutes_to_queue_pop }
    grouper = ->(e) { e.job.role.name }
    sub_grouper = ->(e) { e.roulette.name }
    @table_data = table_data(options, selector, grouper, sub_grouper)
    @subgroup_columns = Role.all.map do |role|
      Roulette.all.map do |roulette|
        { group: role.name, subgroup: roulette.name }
      end
    end.flatten
    @roulette_count = Roulette.count
    @chart_data = chart_data(options, selector, grouper, sub_grouper)
  end
  def total_time
  end
  def roulette_efficiency
  end

  private

  def roulettes
    @roulettes ||= Roulette.all
  end
end
