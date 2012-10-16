# encoding: utf-8 
module NongeneratingSymbolEliminator

	def generating_symbols( productions, generating_symbols )
		bla = productions.detect{ |variable,production| production.any?{ |production_body| production_body.all?{ |symbol| generating_symbols.include?(symbol) } } and ! generating_symbols.include?(variable) }
		if(bla == nil)
			generating_symbols
		else
			generating_symbols( productions, generating_symbols << bla[0] )
		end
	end

	def productions_without_nongenerating_variables( nongenerating_variables, productions )
		productions_clone = productions.dup
		nongenerating_variables.each{ |nongenerating_variable| productions_clone.delete(nongenerating_variable) }
		saida = {}
		productions_clone.each_pair do |variable, production| 
			saida[variable] = production.reject{ |member| ! (member & nongenerating_variables).empty? } 
		end
		saida		
	end	
end  


