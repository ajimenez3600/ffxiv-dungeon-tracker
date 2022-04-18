module Api
	class JobsController < ApplicationController
		def index
			render json: Job.where(is_class: false).sort_by{ |x| x.name }.map(&:name)
		end
	end
end
