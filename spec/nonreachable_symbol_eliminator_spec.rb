# encoding: utf-8
require "simplecov"
SimpleCov.start
require File.expand_path(File.join(".", "spec_helper"), File.dirname(__FILE__))
require "context_free_grammar"    


describe "It eliminates nonreachable symbols of context free grammars" do
  
  before(:each) do
	@terminals = ['a','b']
	@variables = [:S, :A, :B, :C]
    	@start_symbol = :S
	@productions = { 	
		          :S =>  [[:A,:B],['a']],
		          :A =>  [['b']],
		          :B =>  [],
			  :C =>  [['a','b']]
		       }     
    
    @cfgrammar = ContextFreeGrammar.new(@terminals, @variables, @start_symbol, @productions)                                                                                                                   
  end
  
  describe "When eliminating nonreachable symbols" do
  
  it "should find all reachable symbols" do
     @cfgrammar.reachable_symbols( :S, @terminals, @productions).should == [:S, :A, "b", "a"]
  end

  it "should eliminate productions of nonreachable variables" do
     @cfgrammar.productions_without_nonreachable_variables( [:C] , @productions  ).should == {:S=>[[:A, :B], ["a"]], :A=>[["b"]], :B=>[]}
  end

  end
end
