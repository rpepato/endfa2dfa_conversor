# encoding: utf-8 
module ProductionFormatter

	def new_variable( variable_index, variables )
		variable_index[0] = variable_index[0] + 1 
		new_variable = ('X'+'_'+ variable_index[0].to_s).to_sym
		if( variables.include?( new_variable ) )
			new_variable( variable_index, variables )		
		else
			new_variable
		end
	end

	#mais um lugar que dado o value preciso da key
	def existing_production( body, variables, productions )
		variables.detect{|variable| productions[variable].size==1 and productions[variable][0]==body}	
	end

	def format_body(body, variable_index, variables, productions)
		if( body.size==1 )
			body
		elsif( (body - variables).empty? )
			body
		else
			body.map do | symbol |
				if( variables.include?(symbol) ) 
					symbol
				elsif( existing_production( [symbol], variables, productions )==nil )
					new_variable = new_variable( variable_index, variables )
					variables << new_variable
					productions[new_variable]=[[symbol]]
					new_variable
				else
					existing_production( [symbol], variables, productions )
				end
			end	
		end				
	end

	def format_production(variable, variable_index, variables, productions)
		new_production = productions[variable].map{|body| format_body(body, variable_index, variables, productions)}
		productions[variable] = new_production
		new_production	
	end

	def format_productions(variable_index, variables, productions)
		variables.map{ |variable| format_production(variable, variable_index, variables, productions) }
	end

	def break_body(body, variable_index, variables, productions)
		if(body.size>=3 and existing_production( body[body.size-2 .. body.size-1], variables, productions )==nil )
			new_variable = new_variable( variable_index, variables )
			variables << new_variable
			productions[new_variable]=[body[body.size-2 .. body.size-1]]
			break_body(body[0 .. body.size-3] << new_variable, variable_index, variables, productions)
		elsif(body.size>=3)
			new_variable = existing_production( body[body.size-2 .. body.size-1], variables, productions )
			break_body(body[0 .. body.size-3] << new_variable, variable_index, variables, productions)
		else
			body
		end
	end

	def break_production(variable, variable_index, variables, productions)
		new_production = productions[variable].map{|body| break_body(body, variable_index, variables, productions) }
		productions[variable] = new_production
		new_production
	end

	def break_productions(variable_index, variables, productions)
		variables.map{ |variable| break_production(variable, variable_index, variables, productions) }
	end
end  


