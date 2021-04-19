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

    respond_to do |format|
      if @instance_entry.save
        format.html { redirect_to root_path, notice: "Instance was successfully created." }
        format.json { render json: {}, status: :created }
      else
        format.html { redirect_to root_path, status: :unprocessable_entity }
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
    groups = Instance.all.group_by(&:instance_type)
    groups = groups.map do |group|
      { instance_type: group.first, count: groups[group.first].count }
    end
    Instance.all.group_by do |instance|
      if groups.select { |g| g[:instance_type] == instance.instance_type }.first[:count] < 20 then
        "#{instance.instance_type}"
      else
        "#{instance.instance_type} (#{instance.expansion})"
      end
    end
  end
end