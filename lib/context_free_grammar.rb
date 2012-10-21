# encoding: utf-8 
require "recursive_start_symbol_eliminator"
require "epsilon_production_eliminator" 
require "unit_production_eliminator" 
require "nongenerating_symbol_eliminator"
require "nonreachable_symbol_eliminator"
 
class ContextFreeGrammar
  	attr_reader  :terminals, :variables, :start_symbol, :productions

	include RecursiveStartSymbolEliminator
	include EpsilonProductionEliminator
	include UnitProductionEliminator
	include NongeneratingSymbolEliminator
	include NonreachableSymbolEliminator

	def initialize(terminals=[], variables = [], start_symbol = [] , productions={})

		raise ArgumentError, 'Terminals must be not empty'  if terminals==nil || terminals.empty? 
		raise ArgumentError, 'Variables must be not empty'  if variables==nil || variables.empty? 
		raise ArgumentError, 'Start symbol must be not empty'  if  start_symbol==nil 
		raise ArgumentError, 'Productions must be not empty'  if productions==nil || productions.empty?

		raise ArgumentError, 'Variables must contain Start Symbol' unless variables.include?(start_symbol)
		#raise ArgumentError, 'For all Variable exists Production'

		@terminals=terminals    
		@variables = variables                   
		@start_symbol = start_symbol 
		@productions = productions

	end 

	def eliminate_recursive_start_symbol

		nonrecursive_start_symbol = nonrecursive_start_symbol( @start_symbol, @variables, @productions )

		ContextFreeGrammar.new(
			@terminals,
			[nonrecursive_start_symbol] | @variables,
			nonrecursive_start_symbol,
			productions_without_recursive_start_symbol( @start_symbol, @variables, @productions )
		)
	end    

	def eliminate_epsilon_productions
		ContextFreeGrammar.new(
			@terminals-[''],
			@variables,
			@start_symbol,
			productions_without_epsilon_production( @terminals, @variables, @productions )
		)
	end

	def eliminate_unit_productions
		ContextFreeGrammar.new(
			@terminals,
			@variables,
			@start_symbol,
			productions_without_unit_production( @variables, @productions )
		)
	end

	def eliminate_nongenerating_symbols

		generating_symbols = generating_symbols( @productions, @terminals )

		ContextFreeGrammar.new(
			@terminals & generating_symbols,
			@variables & generating_symbols,
			@start_symbol,
			productions_without_nongenerating_variables( @variables - generating_symbols, @productions )
		)
	end

	def eliminate_nonreachable_symbols

		reachable_symbols = reachable_symbols(@start_symbol, @terminals, @productions )

		ContextFreeGrammar.new(
			@terminals & reachable_symbols,
			@variables & reachable_symbols,
			@start_symbol,
			productions_without_nonreachable_variables( @variables - reachable_symbols, @productions )
		)
	end

	def prenormalize
		eliminate_recursive_start_symbol.
		eliminate_epsilon_productions.
		eliminate_unit_productions.
		eliminate_nongenerating_symbols.
		eliminate_nonreachable_symbols
	end
			

end  


