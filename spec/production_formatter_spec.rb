# encoding: utf-8
require "simplecov"
SimpleCov.start
require File.expand_path(File.join(".", "spec_helper"), File.dirname(__FILE__))
require "context_free_grammar"    


describe "It formats productions" do
  
  before(:each) do
	@terminals = ['a','b','0', '1','*','+', '(', ')']
	@variables = [:I, :F, :T,:E]
    	@start_symbol = :I
	@productions = 	
	{
	:E=>[[:E, "+", :T], [:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]],
	:T=>[[:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], 
	:F=>[["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], 
	:I=>[["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]]
	}     
    
    	@cfgrammar = ContextFreeGrammar.new(@terminals, @variables, @start_symbol, @productions)   
	@variable_index = [0]   
                                                                                      
  end
  
  describe "When formating production" do

  it "should create new variable" do
     	@cfgrammar.new_variable( @variable_index, @variables ).should == :X_1
  end

  it "should format body" do
    	@cfgrammar.format_body([:E, "+", :T], @variable_index, @variables, @productions).should == [:E, :X_1, :T]
	@variables.should == [:I, :F, :T,:E,:X_1]
	@productions.should == 
	{
	:E=>[[:E, "+", :T], [:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]],
	:T=>[[:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], 
	:F=>[["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], 
	:I=>[["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]],
	:X_1 => [["+"]]
	}  
  end

  it "should format production" do
    	@cfgrammar.format_production(:I, @variable_index, @variables, @productions).should == [["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]]
	@variables.should == [:I, :F, :T, :E, :X_1, :X_2, :X_3, :X_4]
	@productions.should == 
	{
	:E=>[[:E, "+", :T], [:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], 
	:T=>[[:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], 
	:F=>[["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], 
	:I=> [["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:X_1=>[["a"]], 
	:X_2=>[["b"]], 
	:X_3=>[["0"]], 
	:X_4=>[["1"]]}
  end

  it "should format productions" do
    	@cfgrammar.format_productions(@variable_index, @variables, @productions)
	@variables.should == [:I, :F, :T, :E, :X_1, :X_2, :X_3, :X_4, :X_5, :X_6, :X_7, :X_8]
	@productions.should == 
	{
	:E=>[[:E, :X_8, :T], [:T, :X_7, :F], [:X_5, :E, :X_6], ["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:T=>[[:T, :X_7, :F], [:X_5, :E, :X_6], ["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:F=>[[:X_5, :E, :X_6], ["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:I=>[["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:X_1=>[["a"]], 
	:X_2=>[["b"]], 
	:X_3=>[["0"]], 
	:X_4=>[["1"]], 
	:X_5=>[["("]], 
	:X_6=>[[")"]], 
	:X_7=>[["*"]], 
	:X_8=>[["+"]]
	}
  end

  it "should break body" do
	@cfgrammar.format_productions(@variable_index, @variables, @productions)
    	@cfgrammar.break_body([:E, :X_8, :T], @variable_index, @variables, @productions).should ==[:E, :X_9]
	@variables.should == [:I, :F, :T, :E, :X_1, :X_2, :X_3, :X_4, :X_5, :X_6, :X_7, :X_8, :X_9]
	@productions[:X_9].should == [[:X_8, :T]]
  end

  it "should break production" do
	@cfgrammar.format_productions(@variable_index, @variables, @productions)
    	@cfgrammar.break_production(:F, @variable_index, @variables, @productions).should ==[[:X_5, :X_9], ["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]]
	@variables.should == [:I, :F, :T, :E, :X_1, :X_2, :X_3, :X_4, :X_5, :X_6, :X_7, :X_8, :X_9]
  end

  it "should break productions" do
	@cfgrammar.format_productions(@variable_index, @variables, @productions)
	@cfgrammar.break_productions(@variable_index, @variables, @productions)
	@variables.should == [:I, :F, :T, :E, :X_1, :X_2, :X_3, :X_4, :X_5, :X_6, :X_7, :X_8, :X_9, :X_10, :X_11] 
	@productions.should == 
	{
	:E=>[[:E, :X_11], [:T, :X_10], [:X_5, :X_9], ["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:T=>[[:T, :X_10], [:X_5, :X_9], ["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:F=>[[:X_5, :X_9], ["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:I=>[["a"], ["b"], [:I, :X_1], [:I, :X_2], [:I, :X_3], [:I, :X_4]], 
	:X_1=>[["a"]], 
	:X_2=>[["b"]], 
	:X_3=>[["0"]], 
	:X_4=>[["1"]], 
	:X_5=>[["("]], 
	:X_6=>[[")"]], 
	:X_7=>[["*"]], 
	:X_8=>[["+"]], 
	:X_9=>[[:E, :X_6]], 
	:X_10=>[[:X_7, :F]], 
	:X_11=>[[:X_8, :T]]
	}
  end
  end
end
