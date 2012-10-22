# encoding: utf-8 
module NongeneratingSymbolEliminator

	def generating_symbols( productions, generating_symbols )
		generating_symbol = productions.detect{ |variable,production| production.any?{ |body| body.all?{ |symbol| generating_symbols.include?(symbol) } } and not generating_symbols.include?(variable) }
		if(generating_symbol == nil)
			generating_symbols
		else
			generating_symbols( productions, generating_symbols + [generating_symbol[0]] )
		end
	end

	def productions_without_nongenerating_variables( nongenerating_variables, productions )
		productions_clone = productions.dup
		nongenerating_variables.each{ |nongenerating_variable| productions_clone.delete(nongenerating_variable) }
		result = {}
		productions_clone.each_pair do |variable, production| 
			result[variable] = production.reject{ |body| not (body & nongenerating_variables).empty? } 
		end
		result		
	end	
end  


