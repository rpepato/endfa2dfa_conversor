# encoding: utf-8 
module RecursiveStartSymbolEliminator

	def has_recursive_start_symbol?( start_symbol,  productions )
		productions[start_symbol].any?{ |body| body.include?(start_symbol) }
	end

	def new_start_symbol( start_symbol, variables )
		index = 0
		new_start_symbol = ""
		begin 	
			new_start_symbol = (start_symbol.to_s + "_" + index.to_s).to_sym
			index = index+1
		end while variables.include?( new_start_symbol )
		new_start_symbol
	end

	def nonrecursive_start_symbol( start_symbol, variables, productions )
		if(has_recursive_start_symbol?( start_symbol,  productions ))
			new_start_symbol( start_symbol, variables )
		else
			start_symbol
		end		
	end

	def productions_without_recursive_start_symbol( start_symbol, variables, productions )
		
		if( has_recursive_start_symbol?( start_symbol,  productions ) )
			productions_clone = productions.dup
			new_start_symbol = new_start_symbol( start_symbol, variables ) 
			productions_clone[new_start_symbol] = [[start_symbol]]

			productions_clone	
		else
			productions 
		end 	
	end
 
end  


