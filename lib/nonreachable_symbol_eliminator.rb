# encoding: utf-8 
module NonreachableSymbolEliminator

	def reachable_symbols2( symbol, terminals, reachable_symbols, productions )
		if( terminals.include?(symbol) and ! reachable_symbols.include?(symbol) )
			reachable_symbols << symbol
		elsif( ! reachable_symbols.include?(symbol) )
			productions[symbol].each{|body| body.each{|inner_symbol| reachable_symbols2( inner_symbol, terminals, reachable_symbols << symbol, productions ) }}					
		end
	end

	def reachable_symbols( initial_symbol, terminals , productions )
		reachable_symbols = []
		reachable_symbols2( initial_symbol, terminals, reachable_symbols, productions )
		reachable_symbols.uniq
	end

	def productions_without_nonreachable_variables( nonreachables_variables, productions )
		productions_clone = productions.dup
		nonreachables_variables.each{ |nonreachables_variable| productions_clone.delete(nonreachables_variable) }
		productions_clone	
	end

end  


