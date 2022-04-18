module Api
	class RoulettesController < ApplicationController
		def index
			render json: Roulette.all.map(&:name)
		end
	end
end
