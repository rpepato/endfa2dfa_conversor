# encoding: utf-8
require "simplecov"
SimpleCov.start
require File.expand_path(File.join(".", "spec_helper"), File.dirname(__FILE__))
require "context_free_grammar"    


describe "It eliminates epsilon productions of context free grammars" do
  
  before(:each) do
	@terminals = ['a','b']
	@variables = [:A, :B, :S]
    	@start_symbol = :S
	@productions = { 	
		          :S =>  [[:A,:B]],
		          :A =>  [['a',:A,:A],['']],
		          :B =>  [['b',:B,:B],['']]
		      }     
    
    @cfgrammar = ContextFreeGrammar.new(@terminals, @variables, @start_symbol, @productions)                                                                                                                   
  end
  
  describe "When eliminating epsilon productions" do
  
  it "should assert :A is nullable" do
     @cfgrammar.nullable?(:A,[],@variables, @productions).should == true
  end

  it "should generate all combinations of :A production" do
     @cfgrammar.combinations(['a',:A,:A], @variables, @productions).should == [['a'],['a',:A],['a',:A, :A]]
  end 

  it "should generate all combinations of :S production" do
     @cfgrammar.combinations([:A,:B], @variables, @productions).should == [[],[:B],[:A],[:A,:B]]
  end 

  it "should eliminate epsilon production of :S production" do
     @cfgrammar.production_without_epsilon_production(:S, @variables, @productions).should == [[:B],[:A],[:A,:B]]
  end 

  it "should eliminate epsilon production of :A production" do
     @cfgrammar.production_without_epsilon_production(:A, @variables, @productions).should == [['a'],['a',:A],['a',:A, :A]]
  end  

  it "should eliminate epsilon production of :B production" do
     @cfgrammar.production_without_epsilon_production(:B, @variables, @productions).should == [['b'],['b',:B],['b',:B, :B]]
  end 

  it "should eliminate epsilon production of cfgrammar" do
     @cfgrammar.productions_without_epsilon_production(@terminals, @variables, @productions).should == {:A => [['a'], ['a', :A], ['a', :A, :A]],:B => [['b'], ['b', :B], ['b', :B, :B]],:S => [[:B], [:A], [:A, :B]]}

  end     
  
  end
end
