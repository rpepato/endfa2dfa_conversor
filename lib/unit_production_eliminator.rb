# encoding: utf-8 
module UnitProductionEliminator

	def has_unit_production?(variable, variables, productions)
		productions[variable].any?{ |member| member.size == 1 and ! (variables & member).empty? }	
	end

	def without_unit_productions(variable, variables, productions)
		productions[variable].reject{ |member| member.size == 1 and ! (variables & member).empty? }	
	end
 
	def unit_productions(variable, variables, productions)
		productions[variable].select{ |member| member.size == 1 and ! (variables & member).empty? }	
	end 

	def production_without_unit_production( reached_variable, variables, productions )
		if( ! has_unit_production?(reached_variable, variables, productions) )
			productions[reached_variable]
		else
			without_unit_productions( reached_variable, variables, productions ).concat( unit_productions(reached_variable,  variables, productions ).flat_map{ |variable| production_without_unit_production( variable[0], variables, productions ) } )
		end
	end

	def productions_without_unit_production( variables, productions )
		new_productions = variables.map{ |variable| [variable, production_without_unit_production( variable, variables, productions )] }
		Hash[new_productions]
	end
end  


