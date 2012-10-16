# encoding: utf-8 
module EpsilonProductionEliminator

	def nullable?( variable, variables, productions )
		variables.include?(variable) and
		(
			productions[variable].include?(['']) or 
			productions[variable].any?{ |member| member.all?{|symbol| nullable?(symbol, variables, productions)}}
		)
	end 

	def combination(index, member, terminals, variables, productions)
		if( member.empty? )
			member
		elsif( terminals.include?(member.last) or ! nullable?( member.last, variables, productions ) ) 
			combination(index,member.take(member.size-1), terminals, variables, productions) << member.last
		else
			if( index%2==0 )
				combination(index/2,member.take(member.size-1), terminals, variables, productions)
			else 
				combination(index/2,member.take(member.size-1), terminals, variables, productions) << member.last
			end
		end
	end 

	def number_of_nullable_variables( member, variables, productions)
		2**member.select{|symbol|nullable?( symbol, variables, productions )}.size
	end

	def combinations( member, terminals, variables, productions )  
		0.upto( number_of_nullable_variables( member, variables, productions)-1 ).
		map{|index| combination(index, member, terminals, variables, productions)}.
		reject{ |member| member==[] }.
		uniq 
	end 

	def production_without_epsilon_production( variable, terminals, variables, productions )
		productions[variable].reject{ |member| member==[''] }.
		flat_map{ |member| combinations( member, terminals, variables, productions ) }.
		uniq
	end

	def productions_without_epsilon_production( terminals, variables, productions )
		new_productions = variables.map{ |variable| [variable, production_without_epsilon_production( variable, terminals, variables, productions )] }
		Hash[new_productions]
	end

end  


