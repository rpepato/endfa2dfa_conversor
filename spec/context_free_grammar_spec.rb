# encoding: utf-8
require "simplecov"
SimpleCov.start
require File.expand_path(File.join(".", "spec_helper"), File.dirname(__FILE__))
require "context_free_grammar"    


describe "It normalize context free grammars" do
  
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
    
    @cfgrammar2 = ContextFreeGrammar.new(
	['a','b','0', '1','*','+', '(', ')'], 
	[:I, :F, :T,:E], 
	:I,         
	{ 	
		  :I =>  [['a'],['b'],[:I,'a'],[:I,'b'],[:I,'0'],[:I,'1']],
		  :F =>  [[:I],['(',:E,')']],
		  :T =>  [[:F],[:T,'*',:F]],
		  :E =>  [[:T],[:E,'+',:T]]
	}  
     )       
    
    @cfgrammar3 = ContextFreeGrammar.new(
	['a','b'], 
	[:S, :A, :B], 
	:S, 
	{ 	
		:S =>  [[:A,:B],['a']],
		:A =>  [['b']],
		:B =>  [],
	} ) 

    @cfgrammar4 = ContextFreeGrammar.new(
	['a','b'], 
	[:S, :A, :B, :C], 
	:S, 
	{ 	
		:S =>  [[:A,:B],['a']],
		:A =>  [['b']],
		:B =>  [],
		:C =>  [['a','b']]
	} ) 

    @cfgrammar5 = ContextFreeGrammar.new(
	['0','1',''], 
	[:S, :A, :B, :C], 
	:S, 
	{ 	
		:S =>  [['0',:A,'0'],['1',:B,'1'],[:B,:B]],
		:A =>  [[:C]],
		:B =>  [[:S],[:A]],
		:C =>  [[:S],['']]
	} ) 

      @cfgrammar6 = ContextFreeGrammar.new(
	['a','b',''], 
	[:S, :A, :B], 
	:S, 
	{ 	
		:S =>  [[:A,:S,:B],['']],
		:A =>  [['a',:A,:S],['a']],
		:B =>  [[:S,'b',:S],[:A],['b','b']]
	} )                                                                                                             
  end
  
  describe "When creating" do

    it "should raise an exception notifying null terminals" do
      expect{ContextFreeGrammar.new(nil, @variables, @start_symbol, @productions)
should false}.to raise_error(ArgumentError, "Terminals must be not empty")
    end

    it "should raise an exception notifying empty terminals" do
      expect{ContextFreeGrammar.new([], @variables, @start_symbol, @productions)
should false}.to raise_error(ArgumentError, "Terminals must be not empty")
    end

    it "should raise an exception notifying null variables" do
      expect{ContextFreeGrammar.new(@terminals, nil, @start_symbol, @productions)
should false}.to raise_error(ArgumentError, "Variables must be not empty")
    end

    it "should raise an exception notifying empty variables" do
      expect{ContextFreeGrammar.new(@terminals, [], @start_symbol, @productions)
should false}.to raise_error(ArgumentError, "Variables must be not empty")
    end

    it "should raise an exception notifying null start symbol" do
      expect{ContextFreeGrammar.new(@terminals, @variables, nil, @productions)
should false}.to raise_error(ArgumentError, "Start symbol must be not empty")
    end

    it "should raise an exception notifying null productions" do
      expect{ContextFreeGrammar.new(@terminals, @variables, @start_symbol, nil)
should false}.to raise_error(ArgumentError, "Productions must be not empty")
    end

    it "should raise an exception notifying empty productions" do
      expect{ContextFreeGrammar.new(@terminals, @variables, @start_symbol, {})
should false}.to raise_error(ArgumentError, "Productions must be not empty")
    end

    it "should raise an exception notifying variables doesnt contain start symbol" do
      expect{ContextFreeGrammar.new(@terminals, @variables, :q666, @productions)
should false}.to raise_error(ArgumentError, "Variables must contain Start Symbol")
    end

  it "should eliminate epsilon productions of cfgrammar" do
     @cfgrammar.eliminate_epsilon_productions.productions.should == {:A => [['a'], ['a', :A], ['a', :A, :A]],:B => [['b'], ['b', :B], ['b', :B, :B]],:S => [[:B], [:A], [:A, :B]]}

  end

  it "should mantain terminals" do
     @cfgrammar.eliminate_epsilon_productions.terminals.should == ['a','b']
  end 

  it "should mantain variables" do
     @cfgrammar.eliminate_epsilon_productions.variables.should == [:A,:B,:S]
  end

  it "should mantain start symbol" do
     @cfgrammar.eliminate_epsilon_productions.start_symbol.should == :S
  end 

  it "should eliminate unit production of cfgrammar" do
     @cfgrammar2.eliminate_unit_productions.productions.should == {:I=>[["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], :F=>[["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], :T=>[[:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]], :E=>[[:E, "+", :T], [:T, "*", :F], ["(", :E, ")"], ["a"], ["b"], [:I, "a"], [:I, "b"], [:I, "0"], [:I, "1"]]}

  end

  it "should mantain terminals" do
     @cfgrammar2.eliminate_unit_productions.terminals.should == ['a','b','0', '1','*','+', '(', ')']
  end 

  it "should mantain variables" do
     @cfgrammar2.eliminate_unit_productions.variables.should == [:I, :F, :T,:E]
  end

  it "should mantain start symbol" do
     @cfgrammar2.eliminate_unit_productions.start_symbol.should == :I
  end

  it "should generate productions without nongenerating symbols" do
     @cfgrammar3.eliminate_nongenerating_symbols.productions.should == {:S=>[["a"]], :A=>[["b"]]}
  end

  it "should mantain terminals" do
     @cfgrammar3.eliminate_nongenerating_symbols.terminals.should == ['a','b']
  end 

  it "should eliminate nongenerating variables" do
     @cfgrammar3.eliminate_nongenerating_symbols.variables.should == [:S, :A]
  end

  it "should mantain start symbol" do
     @cfgrammar3.eliminate_nongenerating_symbols.start_symbol.should == :S
  end

  it "should generate productions without nonreachable symbols" do
     @cfgrammar4.eliminate_nonreachable_symbols.productions.should == {:S=>[[:A, :B], ["a"]], :A=>[["b"]]}
  end

  it "should mantain terminals" do
     @cfgrammar4.eliminate_nonreachable_symbols.terminals.should == ['a','b']
  end 

  it "should eliminate nongenerating variables" do
     @cfgrammar4.eliminate_nonreachable_symbols.variables.should == [:S, :A]
  end

  it "should mantain start symbol" do
     @cfgrammar4.eliminate_nonreachable_symbols.start_symbol.should == :S
  end

  it "should generate normalized productions" do
     @cfgrammar5.normalize.productions.should == 
	{
	:S=>[[:X_1, :X_3], [:X_2, :X_4], [:B, :B]], 
	:A=>[[:X_1, :X_3], [:X_2, :X_4], [:B, :B]], 
	:B=>[[:X_1, :X_3], [:X_2, :X_4], [:B, :B]], 
	:X_1=>[["0"]], 
	:X_2=>[["1"]], 
	:X_3=>[[:A, :X_1], ["0"]], 
	:X_4=>[[:B, :X_2], ["1"]]
	}
  end

  it "should generate normalized terminals" do
     @cfgrammar5.normalize.terminals.should ==  ['0', '1' ]
  end

  it "should generate normalized variables" do
     @cfgrammar5.normalize.variables.should ==  [:S, :A, :B, :X_1, :X_2, :X_3, :X_4]
  end

  it "should generate normalized start symbol" do
     @cfgrammar5.normalize.start_symbol.should == :S
  end

  end
end
