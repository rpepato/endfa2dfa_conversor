# encoding: utf-8
require "simplecov"
SimpleCov.start
require File.expand_path(File.join(".", "spec_helper"), File.dirname(__FILE__))
require "context_free_grammar"    


describe "It eliminates nongenerating symbols of context free grammars" do
  
  before(:each) do
	@terminals = ['a','b']
	@variables = [:S, :A, :B]
    	@start_symbol = :S
	@productions = { 	
		          :S =>  [[:A,:B],['a']],
		          :A =>  [['b']],
		          :B =>  [],
		       }     
    
    @cfgrammar = ContextFreeGrammar.new(@terminals, @variables, @start_symbol, @productions)                                                                                                                   
  end
  
  describe "When eliminating nongenerating symbols" do
  
  it "should find all generating symbols" do
     @cfgrammar.generating_symbols( @productions, [].concat(@terminals) ).should == ["a", "b", :S, :A]
  end

  it "should generate productions without nongenerating variables" do
     @cfgrammar.productions_without_nongenerating_variables(  [:B] , @productions  ).should == {:S=>[["a"]], :A=>[["b"]]}
  end

  end
end
