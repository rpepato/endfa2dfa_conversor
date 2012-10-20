# encoding: utf-8 
module EpsilonProductionEliminator

	def nullable?( symbol, visiteds = [], variables, productions )
		if(variables.include?(symbol) and productions[symbol].include?(['']) )
			true
		elsif(variables.include?(symbol) and !visiteds.include?(symbol)) 			
			productions[symbol].any?{ |body| body.all?{|inner_symbol| nullable?(inner_symbol, visiteds << symbol ,variables, productions)}}
		else
			false
		end
	end 
 

	def combinations( body, terminals )  
		if(body == nil or body.empty?)
			[[]]
		elsif(terminals.include?(body.first))
			combinations( body.last(body.size-1), terminals ).map{|combination| combination.dup.unshift(body.first) }
		else
			combinations = combinations( body.last(body.size-1), terminals )
			combinations | combinations.map{|combination| combination.dup.unshift( body.first ) }
		end
	end 

	def production_without_epsilon_production( variable, terminals, productions )
		productions[variable].reject{ |body| body==[''] }.
		flat_map{ |body| combinations( body, terminals ).reject{ |body| body==[]  }  }
	end

	def productions_without_epsilon_production( terminals, variables, productions )
		new_productions = variables.map{ |variable| [variable, production_without_epsilon_production( variable, terminals, productions )] }
		Hash[new_productions]
	end

end  


