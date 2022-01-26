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
    @table_data = InstanceEntry.where(options).all.map do |ie|
      {
        role: ie.job.role.name,
        roulette: ie.roulette.name,
        queue_time: ie.minutes_to_queue_pop,
        level: ie.start_level
      }
    end
  end

  def total_time
    options = { duration_outlier: false, roulette_id: Roulette.all.pluck(:id) }
    @table_data = InstanceEntry.where(options).all.map do |ie|
      {
        role: ie.job.role.name,
        roulette: ie.roulette.name,
        queue_time: ie.minutes_to_queue_pop,
        instance_time: ie.minutes_in_instance,
        level: ie.start_level
      }
    end
  end

  def roulette_efficiency
    options = { duration_outlier: false, roulette_id: Roulette.all.pluck(:id) }
    @table_data = InstanceEntry.where(options).all.map do |ie|
      {
        role: ie.job.role.name,
        roulette: ie.roulette.name,
        queue_time: ie.minutes_to_queue_pop,
        instance_time: ie.minutes_in_instance,
        xp: ie.combat_and_bonus_xp,
        level: ie.start_level
      }
    end
  end

  private

  def roulettes
    @roulettes ||= Roulette.all
  end
end
