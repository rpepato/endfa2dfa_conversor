# encoding: utf-8 
# teste de github
class Conversor
  attr_reader :states, :transition_function, :initial_state, :alphabet, :final_states

  def initialize(states=[], alphabet = [], transition_function = {}, initial_state=[], final_states = [])

    raise ArgumentError, 'States must be not empty'  if states==nil || states.empty? 
    raise ArgumentError, 'Alphabet must be not empty'  if alphabet==nil || alphabet.empty? 
    raise ArgumentError, 'Transition function must be not empty'  if  transition_function==nil || transition_function.empty? 
    raise ArgumentError, 'Initial state must be not null'  if initial_state==nil
    raise ArgumentError, 'Final states must be not empty'  if final_states==nil || final_states.empty?

    raise ArgumentError, 'State must contain Initial state' unless states.include?(initial_state)
    raise ArgumentError, 'State must contain Final states' unless final_states.all?{|final_state| (final_state & states.flatten)==final_state}
    raise ArgumentError, 'State must contain all reached states' unless transition_function.values.flat_map{|transitions| transitions.values}.all?{|reached_state| (reached_state & states.flatten)==reached_state}
  
    raise ArgumentError, 'Alphabet must contain all characters' unless transition_function.values.flat_map{|transitions| transitions.keys}.uniq.all?{|character| alphabet.include?(character)}

    @states=states    
    @transition_function = transition_function                     
    @alphabet = alphabet 
    @initial_state = initial_state
    @final_states = final_states
  end                   

  def eclose(state, transition_function=@transition_function) 
	reached_states = transition_function[state][''].select{|reached_state| reached_state != state}
	if( reached_states.empty?)
	 	state		
	else
		reached_states.flat_map{|reached_state| eclose([reached_state],transition_function)}.concat(state).sort.uniq
	end
  end
  
  def to_dfa
     dfa_transition_function = {} 
     dfa_alphabet = @alphabet.select{|symbol| symbol!=''}                                                                            
     insert_new_state(dfa_transition_function, dfa_alphabet, eclose(@initial_state),@transition_function)   
     Conversor.new(dfa_transition_function.keys, dfa_alphabet, dfa_transition_function, eclose(@initial_state), dfa_final_states(dfa_transition_function,@final_states))
  end  

  def insert_new_state( dfa_transition_function, alphabet, state, transition_function) 

    dfa_transition_function[state] = transitions(state, alphabet , transition_function)

    dfa_transition_function[state].each_pair do |symbol, reached_state|
      if(!dfa_transition_function.has_key?(reached_state))
        insert_new_state(dfa_transition_function, alphabet, reached_state, transition_function)
      end
    end
  end

  def transitions( state, alphabet, transition_function)
	transitions = alphabet.map{|symbol| transition(state, symbol, transition_function)}
	Hash[transitions]
  end

  def transition( states, symbol, transition_function)
	reached_states = states.flat_map{ |state| eclose([state], transition_function)}.flat_map{ |state| transition_function[[state]][symbol]}.flat_map{ |state| eclose([state],transition_function)}.uniq.sort 
	[symbol, reached_states]
  end

  def dfa_final_states(transition_function,final_states)
    	transition_function.keys.select{|state| final_states.one?{|final_state| ! (final_state & state).empty? } }.uniq.sort
  end

  def to_nfa
	nfa_alphabet = @alphabet.select{|symbol| symbol!=''}
	Conversor.new(@states, nfa_alphabet, nfa_transition_function(@transition_function, nfa_alphabet), @initial_state, nfa_final_states(@transition_function, @final_states))
  end
  
  def nfa_transition_function(old_automaton, alphabet)
	nfa_states = old_automaton.keys.map{|state| [state, transitions(state, alphabet, old_automaton)]}
	Hash[nfa_states]
  end

  def nfa_final_states(transition_function, final_states)
	( transition_function.keys.select{|state| ! ( eclose(state,transition_function) & final_states ).empty? } + final_states ).uniq.sort		
  end	
end   


