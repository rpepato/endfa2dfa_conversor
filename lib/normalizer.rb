# encoding: utf-8 
# teste de github
class Normalizer
  	attr_reader  :terminals, :variables, :start_symbol, :productions

	def initialize(terminals=[], variables = [], start_symbol = [] , productions={})

		raise ArgumentError, 'Terminals must be not empty'  if terminals==nil || terminals.empty? 
		raise ArgumentError, 'Variables must be not empty'  if variables==nil || variables.empty? 
		raise ArgumentError, 'Start symbol must be not empty'  if  start_symbol==nil 
		raise ArgumentError, 'Productions must be not empty'  if productions==nil || productions.empty?

		raise ArgumentError, 'Variables must contain Start Symbol' unless variables.include?(start_symbol)
		#    raise ArgumentError, 'For all Variable exists Production' unless final_states.all?{|final_state| (final_state & states.flatten)==final_state}

		@terminals=terminals    
		@variables = variables                   
		@start_symbol = start_symbol 
		@productions = productions

	end     

#cheira a loop infinito, pensar melhor
	def nullable?( variable, variables = @variables, productions=@productions  )
		variables.include?(variable) and
		(productions[variable].include?([:epsilon]) or 
		productions[variable].any?{|member| member.all?{|symbol| and nullable?(symbol)}})
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

	def new_production( variable, terminals, variables, productions )
		productions[variable].reject{ |member| member==[:epsilon] }.
		flat_map{ |member| combinations( member, terminals, variables, productions ) }.
		uniq
	end

	def new_productions( terminals, variables, productions )
		new_productions = variables.map{ |variable| [variable, new_production( variable, terminals, variables, productions )] }
		Hash[new_productions]
	end

	def eliminate_epsilon_production
		Normalizer.new(
			@terminals,
			@variables,
			@start_symbol,
			new_productions( @terminals, @variables, @productions )
		)
	end
			

end  


