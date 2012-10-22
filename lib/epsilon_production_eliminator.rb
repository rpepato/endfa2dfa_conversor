# encoding: utf-8 
module EpsilonProductionEliminator

	def nullable?( symbol, visiteds = [], variables, productions )
		if(variables.include?(symbol) and productions[symbol].include?(['']) )
			true
		elsif(variables.include?(symbol) and not visiteds.include?(symbol)) 			
			productions[symbol].any?{ |body| body.all?{|inner_symbol| nullable?(inner_symbol, visiteds << symbol, variables, productions )}}
		else
			false
		end
	end 
 

	def combinations( body, variables, productions )  
		if(body == nil or body.empty?)
			[[]]
		elsif( not nullable?( body.first, variables, productions ) )
			combinations( body.last(body.size-1), variables, productions ).map{|combination| combination.dup.unshift(body.first) }
		else
			combinations = combinations( body.last(body.size-1), variables, productions )
			combinations | combinations.map{|combination| combination.dup.unshift( body.first ) }
		end
	end 

	def production_without_epsilon_production( variable, variables, productions )
		productions[variable].reject{ |body| body==[''] }.
		flat_map{ |body| combinations( body, variables, productions ).reject{ |body| body==[]  }  }
	end

	def productions_without_epsilon_production( terminals, variables, productions )
		new_productions = variables.map{ |variable| [variable, production_without_epsilon_production( variable, variables, productions )] }
		Hash[new_productions]
	end

end  


