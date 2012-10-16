# encoding: utf-8 
require "epsilon_production_eliminator" 
require "unit_production_eliminator" 
require "nongenerating_symbol_eliminator"
 
class ContextFreeGrammar
  	attr_reader  :terminals, :variables, :start_symbol, :productions

	include EpsilonProductionEliminator
	include UnitProductionEliminator
	include NongeneratingSymbolEliminator

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

	def eliminate_epsilon_productions
		ContextFreeGrammar.new(
			@terminals,
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

		generating_symbols = generating_symbols( productions, [].concat(terminals) )

		ContextFreeGrammar.new(
			[].concat(@terminals) & [].concat(generating_symbols),
			[].concat(@variables) & [].concat(generating_symbols),
			@start_symbol,
			productions_without_nongenerating_variables( [].concat(@variables) - generating_symbols, @productions )
		)
	end	

end  

