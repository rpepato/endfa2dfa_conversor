# encoding: utf-8
require 'simplecov'
SimpleCov.start
require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'conversor'    


describe "E-NDFA To DFA conversor" do
  
  before(:each) do
    alphabect = ['', '+', '-', '.', '0', '1', '2', '3','4','5','6','7','8','9']
    endfa_hash       = { 	
                          [] =>  {
                                    ''        =>  [],
                                    '+'       =>  [],
                                    '-'       =>  [],
                                    '.'       =>  [],
                                    '0'       =>  [],  
                                    '1'       =>  [],  
                                    '2'       =>  [],  
                                    '3'       =>  [],  
                                    '4'       =>  [],  
                                    '5'       =>  [],  
                                    '6'       =>  [],  
                                    '7'       =>  [],  
                                    '8'       =>  [],  
                                    '9'       =>  [] 
                                  },
                          [:q0] =>  {
                                    ''        =>  [:q1],
                                    '+'       =>  [:q1],
                                    '-'       =>  [:q1],
                                    '.'       =>  [],
                                    '0'       =>  [],  
                                    '1'       =>  [],  
                                    '2'       =>  [],  
                                    '3'       =>  [],  
                                    '4'       =>  [],  
                                    '5'       =>  [],  
                                    '6'       =>  [],  
                                    '7'       =>  [],  
                                    '8'       =>  [],  
                                    '9'       =>  [] 
                                  },
                          [:q1] =>  {
                                    ''        =>  [],
                                    '+'       =>  [],
                                    '-'       =>  [],
                                    '.'       =>  [:q2],
                                    '0'       =>  [:q1, :q4],  
                                    '1'       =>  [:q1, :q4],  
                                    '2'       =>  [:q1, :q4],  
                                    '3'       =>  [:q1, :q4],  
                                    '4'       =>  [:q1, :q4],  
                                    '5'       =>  [:q1, :q4],  
                                    '6'       =>  [:q1, :q4],  
                                    '7'       =>  [:q1, :q4],  
                                    '8'       =>  [:q1, :q4],  
                                    '9'       =>  [:q1, :q4] 
                                  }, 
                          [:q2] =>  {
                                     ''        =>  [],
                                     '+'       =>  [],
                                     '-'       =>  [],
                                     '.'       =>  [],
                                     '0'       =>  [:q3],  
                                     '1'       =>  [:q3],  
                                     '2'       =>  [:q3],  
                                     '3'       =>  [:q3],  
                                     '4'       =>  [:q3],  
                                     '5'       =>  [:q3],  
                                     '6'       =>  [:q3],  
                                     '7'       =>  [:q3],  
                                     '8'       =>  [:q3],  
                                     '9'       =>  [:q3]
                                  },
                          [:q3] =>  {
                                     ''        =>  [:q5],
                                     '+'       =>  [],
                                     '-'       =>  [],
                                     '.'       =>  [],
                                     '0'       =>  [:q3],  
                                     '1'       =>  [:q3],  
                                     '2'       =>  [:q3],  
                                     '3'       =>  [:q3],  
                                     '4'       =>  [:q3],  
                                     '5'       =>  [:q3],  
                                     '6'       =>  [:q3],  
                                     '7'       =>  [:q3],  
                                     '8'       =>  [:q3],  
                                     '9'       =>  [:q3]
                                  },                                                                                                    
                          [:q4] =>  {
                                     ''        =>  [],
                                     '+'       =>  [],
                                     '-'       =>  [],
                                     '.'       =>  [:q3],
                                     '0'       =>  [],  
                                     '1'       =>  [],  
                                     '2'       =>  [],  
                                     '3'       =>  [],  
                                     '4'       =>  [],  
                                     '5'       =>  [],  
                                     '6'       =>  [],  
                                     '7'       =>  [],  
                                     '8'       =>  [],  
                                     '9'       =>  []
                                  },
                          [:q5] =>  {
                                     ''        =>  [],
                                     '+'       =>  [],
                                     '-'       =>  [],
                                     '.'       =>  [],
                                     '0'       =>  [],  
                                     '1'       =>  [],  
                                     '2'       =>  [],  
                                     '3'       =>  [],  
                                     '4'       =>  [],  
                                     '5'       =>  [],  
                                     '6'       =>  [],  
                                     '7'       =>  [],  
                                     '8'       =>  [],  
                                     '9'       =>  []
                                  }                                                                      
                  		}   
    @endfa = Conversor.new(endfa_hash.keys, alphabect, endfa_hash, [:q0], [[:q5]])                 		 
    enfa       = { 	
		          [] =>  {
		                    ''        =>  [],
		                    'a'       =>  [],
		                    'b'       =>  []
		                  },
		          [:q0] =>  {
		                    ''        =>  [:q1],
		                    'a'       =>  [],
		                    'b'       =>  []
		                  },
		          [:q1] =>  {
		                    ''        =>  [],
		                    'a'       =>  [:q1,:q2],
		                    'b'       =>  []
		                  }, 
		          [:q2] =>  {
		                    ''        =>  [:q3],
		                    'a'       =>  [],
		                    'b'       =>  [:q4]
		                  },
		          [:q3] =>  {
		                    ''        =>  [],
		                    'a'       =>  [:q4],
		                    'b'       =>  []
		                  },
		          [:q4] =>  {
		                    ''        =>  [:q1],
		                    'a'       =>  [],
		                    'b'       =>  []
		                  }                                                                 
		       }                  	
     @another_enfa = Conversor.new(enfa.keys, ['','a','b'], enfa, [:q0], [[:q1]])                                                                                                    
  end
  
  describe "When converting" do

    it "should raise an exception notifying null states" do
      expect{Conversor.new(nil, @endfa.alphabet, @endfa.transition_function, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'States must be not empty')
    end

    it "should raise an exception notifying empty states" do
      expect{Conversor.new([], @endfa.alphabet, @endfa.transition_function, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'States must be not empty')
    end

    it "should raise an exception notifying null alphabet" do
      expect{Conversor.new(@endfa.states, nil, @endfa.transition_function, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'Alphabet must be not empty')
    end

    it "should raise an exception notifying empty alphabet" do
      expect{Conversor.new(@endfa.states, [], @endfa.transition_function, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'Alphabet must be not empty')
    end

    it "should raise an exception notifying null transition function" do
      expect{Conversor.new(@endfa.states, @endfa.alphabet, nil, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'Transition function must be not empty')
    end

    it "should raise an exception notifying empty transition function" do
      expect{Conversor.new(@endfa.states, @endfa.alphabet, {}, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'Transition function must be not empty')
    end

    it "should raise an exception notifying null initial state" do
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, nil, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'Initial state must be not null')
    end

    it "should raise an exception notifying null final states" do
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, @endfa.initial_state, nil)
should false}.to raise_error(ArgumentError, 'Final states must be not empty')
    end

    it "should raise an exception notifying null final state" do
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, @endfa.initial_state, [])
should false}.to raise_error(ArgumentError, 'Final states must be not empty')
    end

    it "should raise an exception notifying states doesnt contain initial state" do
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, [:q666], @endfa.final_states)
should false}.to raise_error(ArgumentError, 'State must contain Initial state')
    end

    it "should raise an exception notifying states doesnt contain final states" do
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, @endfa.initial_state, [[:q51],[:q69]])
should false}.to raise_error(ArgumentError, 'State must contain Final states')
    end

    it "should raise an exception notifying states doesnt contain reached state" do
      @endfa.transition_function[[:q2]]['+']=[:q666]
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'State must contain all reached states')
    end

    it "should raise an exception notifying alphabet doesnt contain character" do
      @endfa.transition_function[[:q2]]['z']=[:q4]
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, @endfa.initial_state,@endfa.final_states)
should false}.to raise_error(ArgumentError, 'Alphabet must contain all characters')
    end

    it "should raise an exception notifying initial states without transition" do
      @endfa.transition_function[[:q0]]['']=[:q0]
      @endfa.transition_function[[:q0]]['+']=[:q0]
      @endfa.transition_function[[:q0]]['-']=[:q0]
      expect{Conversor.new(@endfa.states, @endfa.alphabet, @endfa.transition_function, @endfa.initial_state, @endfa.final_states)
should false}.to raise_error(ArgumentError, 'Initial state must have transition for another state')
    end

    it "should get simple e-close for state" do
      @endfa.eclose([:q1]).should == [:q1]
      @endfa.eclose([:q1]).should == [:q1]      
    end                             
    
    it "should get composite e-close for state" do
       @endfa.eclose([:q3]).should == [:q3, :q5]
    end  
 
    it "should get recursive e-close for state" do

    enfa       = { 	
		          [] =>  {
		                    ''        =>  [],
		                    'a'       =>  [],
		                    'b'       =>  []
		                  },
		          [:q0] =>  {
		                    ''        =>  [:q1,:q3],
		                    'a'       =>  [],
		                    'b'       =>  []
		                  },
		          [:q1] =>  {
		                    ''        =>  [:q2],
		                    'a'       =>  [],
		                    'b'       =>  []
		                  }, 
		          [:q2] =>  {
		                    ''        =>  [:q5],
		                    'a'       =>  [],
		                    'b'       =>  []
		                  },
		          [:q3] =>  {
		                    ''        =>  [],
		                    'a'       =>  [:q4],
		                    'b'       =>  []
		                  },
		          [:q4] =>  {
		                    ''        =>  [:q6],
		                    'a'       =>  [],
		                    'b'       =>  [:q5]
		                  } , 
			  [:q5] =>  {
		                    ''        =>  [],
		                    'a'       =>  [],
		                    'b'       =>  []
				  }  , 
			  [:q6] =>  {
		                    ''        =>  [],
		                    'a'       =>  [],
		                    'b'       =>  []
				  }                                                          
		       } 

       Conversor.new(enfa.keys,['','a','b'],enfa,[:q0],[[:q6]]).eclose([:q0],enfa).should == [:q0, :q1, :q2, :q3, :q5]
    end  
   
    it "should get e-close for epsilon state" do
       @endfa.eclose([]).should == []
    end

    it "should get extended_transition for state" do
       @another_enfa.transition([:q1],'a',@another_enfa.transition_function).should == ['a',[:q1,:q2,:q3]]
    end

    it "should get all transitions for state" do
       @another_enfa.transitions([:q1],['a','b'],@another_enfa.transition_function).should == {"a"=>[:q1, :q2, :q3], "b"=>[]} 
    end

    
    it "should convert an e-ndfa to a dfa" do
      dfa =   {
                [:q0,:q1] => {
                            '+'         => [:q1],
                            '-'         => [:q1],
                            '.'         => [:q2],
                            '0'         => [:q1, :q4],
                            '1'         => [:q1, :q4],
                            '2'         => [:q1, :q4],
                            '3'         => [:q1, :q4],
                            '4'         => [:q1, :q4],
                            '5'         => [:q1, :q4],
                            '6'         => [:q1, :q4],
                            '7'         => [:q1, :q4],
                            '8'         => [:q1, :q4],
                            '9'         => [:q1, :q4]
                          },
                [:q1] =>    {
                            '+'         => [],
                            '-'         => [],
                            '.'         => [:q2],
                            '0'         => [:q1, :q4],
                            '1'         => [:q1, :q4],
                            '2'         => [:q1, :q4],
                            '3'         => [:q1, :q4],
                            '4'         => [:q1, :q4],
                            '5'         => [:q1, :q4],
                            '6'         => [:q1, :q4],
                            '7'         => [:q1, :q4],
                            '8'         => [:q1, :q4],
                            '9'         => [:q1, :q4]
                          },   
                [:q1,:q4] => {
                            '+'         => [],
                            '-'         => [],
                            '.'         => [:q2, :q3, :q5],
                            '0'         => [:q1, :q4],
                            '1'         => [:q1, :q4],
                            '2'         => [:q1, :q4],
                            '3'         => [:q1, :q4],
                            '4'         => [:q1, :q4],
                            '5'         => [:q1, :q4],
                            '6'         => [:q1, :q4],
                            '7'         => [:q1, :q4],
                            '8'         => [:q1, :q4],
                            '9'         => [:q1, :q4]
                          },
                [:q2] =>    {
                            '+'         => [],
                            '-'         => [],
                            '.'         => [],
                            '0'         => [:q3, :q5],
                            '1'         => [:q3, :q5],
                            '2'         => [:q3, :q5],
                            '3'         => [:q3, :q5],
                            '4'         => [:q3, :q5],
                            '5'         => [:q3, :q5],
                            '6'         => [:q3, :q5],
                            '7'         => [:q3, :q5],
                            '8'         => [:q3, :q5],
                            '9'         => [:q3, :q5]
                          },
                [:q2,:q3,:q5] =>  {
                            '+'         => [],
                            '-'         => [],
                            '.'         => [],
                            '0'         => [:q3, :q5],
                            '1'         => [:q3, :q5],
                            '2'         => [:q3, :q5],
                            '3'         => [:q3, :q5],
                            '4'         => [:q3, :q5],
                            '5'         => [:q3, :q5],
                            '6'         => [:q3, :q5],
                            '7'         => [:q3, :q5],
                            '8'         => [:q3, :q5],
                            '9'         => [:q3, :q5]
                          },
                [:q3,:q5] => {
                            '+'         => [],
                            '-'         => [],
                            '.'         => [],
                            '0'         => [:q3, :q5],
                            '1'         => [:q3, :q5],
                            '2'         => [:q3, :q5],
                            '3'         => [:q3, :q5],
                            '4'         => [:q3, :q5],
                            '5'         => [:q3, :q5],
                            '6'         => [:q3, :q5],
                            '7'         => [:q3, :q5],
                            '8'         => [:q3, :q5],
                            '9'         => [:q3, :q5]
                          },
                [] =>     {
                            '+'         => [],
                            '-'         => [],
                            '.'         => [],
                            '0'         => [],
                            '1'         => [],
                            '2'         => [],
                            '3'         => [],
                            '4'         => [],
                            '5'         => [],
                            '6'         => [],
                            '7'         => [],
                            '8'         => [],
                            '9'         => []
                          }                                                                                                                                                         
              }    
      @endfa.to_dfa.transition_function.should == dfa
    end   
    
    it "should set new initial state" do
      @endfa.to_dfa.initial_state.should == [:q0,:q1]
    end   
    
    it "test" do
      @endfa.to_dfa.final_states.should == [[:q2,:q3,:q5],[:q3,:q5]]
    end
    
    it "should convert an e-nfa to a nfa" do

    nfa       = { 	
                          [] =>  {
                                    'a'       =>  [],
                                    'b'       =>  []
                                  },
                          [:q0] =>  {
                                    'a'       =>  [:q1,:q2,:q3],
                                    'b'       =>  []
                                  },
                          [:q1] =>  {
                                    'a'       =>  [:q1,:q2,:q3],
                                    'b'       =>  []
                                  }, 
                          [:q2] =>  {
                                    'a'       =>  [:q1,:q4],
                                    'b'       =>  [:q1,:q4],
                                  },
                          [:q3] =>  {
                                    'a'       =>  [:q1,:q4],
                                    'b'       =>  []
                                  } ,
			  [:q4] =>  {
                                    'a'       =>  [:q1,:q2,:q3],
                                    'b'       =>  []
                                  }                                                                  
                       }  
	@another_enfa.to_nfa.transition_function.should  ==  nfa 
    end

  end
  
end
