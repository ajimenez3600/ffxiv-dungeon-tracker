class InstanceEntriesController < ApplicationController

  def new
    @instance_entry = InstanceEntry.new
    @jobs = Job.all.map(&:name)
    @instances = get_instance_groups
    @roulettes = Roulette.all.map(&:name)
  end

  def create
    @instance_entry = InstanceEntry.new(instance_entry_params)
    @instance_entry.instance = Instance.find_by_name(params[:instance_selection])
    @instance_entry.job = Job.find_by_name(params[:job_name])
    @instance_entry.roulette = Roulette.find_by_name(params[:roulette_name]) if params[:roulette_name].present?

    @instance_entry.xp_bonus ||= 0
    @instance_entry.roulette_bonus ||= 0
    @instance_entry.new_player_bonus ||= 0
    @instance_entry.role_in_need_bonus ||= 0
    @instance_entry.other_bonus ||= 0
    @instance_entry.commends ||= 0

    respond_to do |format|
      if @instance_entry.save
        format.html { redirect_to root_path }
        format.json { render json: {}, status: :created }
      else
        format.html { redirect_to root_path }
        format.json { render json: @instance_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def instance_entry_params
    params.permit(
      :start_time,
      :start_level,
      :start_xp,
      :queue_pop_time,
      :finish_time,
      :finish_level,
      :finish_xp,
      :xp_bonus,
      :roulette_bonus,
      :new_player_bonus,
      :role_in_need_bonus,
      :other_bonus,
      :commends,
      :queue_outlier,
      :duration_outlier,
      :xp_outlier,
      :notes
    )
  end

  def get_instance_groups
    group = { }
    expansions = Expansion.all.sort_by(&:api_id).to_a
    Instance.all.map(&:instance_type).uniq.each do |instance_type|
      instances = Instance.where(instance_type: instance_type).all
      if instances.count > 20 then
        expansion_group = { }
        expansions.each do |expansion|
          instances = Instance
            .where(instance_type: instance_type, expansion_id: expansion.id)
            .order(required_level: :asc, required_item_level: :asc, name: :asc)
          expansion_group[expansion.name] = instances if instances.count > 0
        end
        group[instance_type] = expansion_group
      else
        group[instance_type] = instances
      end
    end
    group
  end
end