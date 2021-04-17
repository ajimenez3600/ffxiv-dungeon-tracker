class InstanceEntriesController < ApplicationController

  def new
    @instance_entry = InstanceEntry.new
    @jobs = ['dragoon', 'scholar']
    @instances = Instance.all.group_by do |instance|
      if instance.expansion.blank?
        "#{instance.instance_type}"
      else
        "#{instance.instance_type} (#{instance.expansion})"
      end
    end
  end

  def create
    @instance_entry = InstanceEntry.new(instance_entry_params)
    @instance_entry.instance = Instance.find_by_name(params[:instance_selection])
    @instance_entry.job = Job.find_by_name(params[:job_name])

    respond_to do |format|
      if @instance_entry.save
        format.html { render :new, notice: "Instance was successfully created." }
        format.json { render json: {}, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instance_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def instance_entry_params
      params[:queue_outlier?] = params.delete(:queue_outlier) if params[:queue_outlier].present?
      params[:duration_outlier?] = params.delete(:duration_outlier) if params[:duration_outlier].present?
      params[:xp_outlier?] = params.delete(:xp_outlier) if params[:xp_outlier].present?

      params.permit(
        :start_time,
        :roulette_name,
        :job_name,
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
        :queue_outlier?,
        :duration_outlier?,
        :xp_outlier?,
        :notes
      )
    end
end
