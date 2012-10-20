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

	def production_without_unit_production( symbol, visiteds = [], variables, productions )
		if(!visiteds.include?(symbol) and ! has_unit_production?(symbol, variables, productions) )
			productions[symbol]
		elsif(!visiteds.include?(symbol))
			without_unit_productions( symbol, variables, productions ).
			concat( 
				unit_productions( symbol, variables, productions ).
				flat_map{ |variable| production_without_unit_production( variable[0], visiteds << symbol, variables, productions ) } 
			)
		else
			[]
		end
	end

	def productions_without_unit_production( variables, productions )
		new_productions = variables.map{ |variable| [variable, production_without_unit_production( variable, variables, productions )] }
		Hash[new_productions]
	end
end  


