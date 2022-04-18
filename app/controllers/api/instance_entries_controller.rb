module Api
	class InstanceEntriesController < ApplicationController
		def create
	    @instance_entry = InstanceEntry.new(instance_entry_params)
 		  @instance_entry.instance = Instance.find_by_name(params[:instance_name])
    	@instance_entry.job = Job.find_by_name(params[:job_name])
    	@instance_entry.roulette = Roulette.find_by_name(params[:roulette_name]) if params[:roulette_name].present?
    	@instance_entry.patch_number = Rails.application.config.patch_number
    	@instance_entry.lune_tracker = request.remote_ip

    	@instance_entry.queue_outlier = params[:queue_outlier]
    	@instance_entry.duration_outlier = params[:duration_outlier]
    	@instance_entry.xp_outlier = params[:xp_outlier]

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
      	:notes
    	)
  	end
	end
end
