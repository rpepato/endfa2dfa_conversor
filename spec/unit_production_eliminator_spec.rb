# encoding: utf-8
require "simplecov"
SimpleCov.start
require File.expand_path(File.join(".", "spec_helper"), File.dirname(__FILE__))
require "context_free_grammar"    


describe "It eliminates unit productions of context free grammars" do
  
  before(:each) do
	@terminals = ['a','b','0', '1','*','+', '(', ')']
	@variables = [:I, :F, :T,:E]
    	@start_symbol = :I
	@productions = { 	
		          :I =>  [['a'],['b'],[:I,'a'],[:I,'b'],[:I,'0'],[:I,'1']],
		          :F =>  [[:I],['(',:E,')']],
		          :T =>  [[:F],[:T,'*',:F]],
		          :E =>  [[:T],[:E,'*',:T]]
		       }     
    
    @cfgrammar = ContextFreeGrammar.new(@terminals, @variables, @start_symbol, @productions)                                                                                                                   
  end
  
  describe "When eliminating unit productions" do
  
  it "should assert production don't have unit production" do
     @cfgrammar.has_unit_production?(:I, @variables, @productions).should == false
  end

  it "should assert production has unit production" do
     @cfgrammar.has_unit_production?(:F, @variables, @productions).should == true
  end

  it "should assert production has unit production" do
     @cfgrammar.has_unit_production?(:T, @variables, @productions).should == true
  end

  it "should assert production has unit production" do
     @cfgrammar.has_unit_production?(:E, @variables, @productions).should == true
  end

  it "should eliminate unit production of :I production" do
     @cfgrammar.without_unit_productions(:I, @variables, @productions).should == @productions[:I]
  end

  it "should eliminate unit production of :F production" do
     @cfgrammar.without_unit_productions(:F, @variables, @productions).should == [['(',:E,')']]
  end

  it "should eliminate unit production of :T production" do
     @cfgrammar.without_unit_productions(:T, @variables, @productions).should == [[:T,'*',:F]]
  end

  it "should eliminate unit production of :E production" do
     @cfgrammar.without_unit_productions(:E, @variables, @productions).should == [[:E,'*',:T]]
  end

  it "should find unit productions from :I production" do
     @cfgrammar.unit_productions(:I, @variables, @productions).should == []
  end

  it "should find unit productions from :F production" do
     @cfgrammar.unit_productions(:F, @variables, @productions).should == [[:I]]
  end

  it "should find unit productions from :T production" do
     @cfgrammar.unit_productions(:T, @variables, @productions).should == [[:F]]
  end

  it "should find unit productions from :E production" do
     @cfgrammar.unit_productions(:E, @variables, @productions).should == [[:T]]
  end

  it "should eliminate unit production of unit :I elimination" do
     @cfgrammar.production_without_unit_production(:I, @variables, @productions).should == @productions[:I]
  end

  it "should eliminate unit production of unit :F elimination" do
     @cfgrammar.production_without_unit_production(:F, @variables, @productions).should == [['(', :E, ')'], ['a'], ['b'], [:I, 'a'], [:I, 'b'], [:I, '0'], [:I, '1']]
  end

  it "should eliminate unit production of unit :T elimination" do
     @cfgrammar.production_without_unit_production(:T, @variables, @productions).should == [[:T, '*', :F], ['(', :E, ')'], ['a'], ['b'], [:I, 'a'], [:I, 'b'], [:I, '0'], [:I, '1']] 
  end

  it "should eliminate unit production of unit :E elimination" do
     @cfgrammar.production_without_unit_production(:E, @variables, @productions).should == [[:E, '*', :T], [:T, '*', :F], ['(', :E, ')'], ['a'], ['b'], [:I, 'a'], [:I, 'b'], [:I, '0'], [:I, '1']]
  end 
 
  end
end
