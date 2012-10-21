# encoding: utf-8
require "simplecov"
SimpleCov.start
require File.expand_path(File.join(".", "spec_helper"), File.dirname(__FILE__))
require "context_free_grammar"    


describe "It eliminates recursive start symbol of context free grammars" do
  
  before(:each) do
	@terminals = ['a','b']
	@variables = [:S, :A, :B]
    	@start_symbol = :S
	@productions = { 	
		          :S =>  [[:S],[:A,:B],['a']],
		          :A =>  [['b']],
		          :B =>  [],
		       }     
    
    @cfgrammar = ContextFreeGrammar.new(@terminals, @variables, @start_symbol, @productions)                                                                                                                   
  end
  
  describe "When eliminating recursive start symbol" do
  
  it "should assert cfg has recursive start symbol" do
     @cfgrammar.has_recursive_start_symbol?( @start_symbol, @productions ).should == true
  end

  it "should create new start symbol :S_0" do
     @cfgrammar.new_start_symbol( @start_symbol, @variables ).should == :S_0
  end

  it "should create new start symbol :S_2" do
     @cfgrammar.new_start_symbol( @start_symbol, @variables + [:S_0,:S_1] ).should == :S_2
  end

  it "should create nonrecursive start symbol" do
     @cfgrammar.nonrecursive_start_symbol( @start_symbol, @variables, @productions ).should == :S_0
  end

  it "should mantain nonrecursive start symbol" do
     @productions[:S] =  [[:A,:B],['a']]
     @cfgrammar.nonrecursive_start_symbol( @start_symbol, @variables, @productions ).should == :S
  end

  it "should eliminate recursive start symbol" do
     @cfgrammar.productions_without_recursive_start_symbol( @start_symbol, @variables, @productions ).should ==  {:S=>[[:S], [:A, :B], ["a"]], :A=>[["b"]], :B=>[], :S_0=>[[:S]]}
  end

  end
end
