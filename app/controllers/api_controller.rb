class ApiController < ApplicationController
	def instances
		render json: get_instance_groups
	end
	def jobs
		render json: Job.where(is_class: false).sort_by{ |x| x.name }.map(&:name)
	end
	def roulettes
		render json: Roulette.all.map(&:name)
	end

	private

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
				.map(&:name)
			  expansion_group[expansion.name] = instances if instances.count > 0
			end
			group[instance_type] = expansion_group
		  else
			group[instance_type] = instances.map(&:name)
		  end
		end
		group
	  end
end