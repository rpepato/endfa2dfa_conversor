# encoding: utf-8 
# teste de github
class Conversor
  attr_reader :automaton
  attr_reader :new_initial_state

  def initialize(automaton = {}, alphabet = [], final_states = [], initial_state=[])
    @automaton = automaton                     
    @alphabet = alphabet 
    @initial_state = initial_state
    @new_initial_state = []
    @final_states = final_states
    @new_final_states = []
  end                     
  
  def eclose(state, states=@automaton)  
    remove_empty_states_when_there_are_many_states(  (state+states[state]['']).uniq )
  end
  
  def to_dfa
     dfa = {}                   
     @new_initial_state = eclose(@initial_state)                                                          
     insert_new_state(dfa, @new_initial_state) 
     @new_final_states = dfa_final_state(dfa)   
     dfa
  end  
  
  def final_states_after_processing
    @new_final_states.sort
  end

  def insert_new_state(hash, state)

    transitions = transitions(state, @alphabet.select {|item| item != ''} , @automaton)

    hash[state] = transitions

    transitions.each_pair do |key, value|
      if(!hash.has_key?(value))
        insert_new_state(hash, value)
      end
    end

  end

  def transitions( state, alphabet, automaton)
	transitions = alphabet.map{|symbol| extended_transition(state, symbol, automaton)}
	Hash[transitions]
  end

  def extended_transition( states, symbol, automaton)
	next_states = states.flat_map{ |state| eclose([state], automaton)}.flat_map{ |state| automaton[[state]][symbol]}.flat_map{ |state| eclose([state],automaton)}.sort.uniq 
	[symbol, remove_empty_states_when_there_are_many_states(next_states)]
  end

  def remove_empty_states_when_there_are_many_states(states)
    	(states.size>1)? states.select{|state| state!=:ø} : states
  end

  def dfa_final_state(hash)
    	hash.keys.select{|state| @final_states.one?{|final_state| ! (final_state & state).empty? } }
  end
  
  def array_to_hash_symbol(array)
      array.sort.map{|sym| sym.to_s}.join("_").to_sym
  end

  def to_nfa
	nfa_alphabet = @alphabet.select{|symbol| symbol!=''}
	Conversor.new(nfa_automaton(@automaton, nfa_alphabet), nfa_alphabet, nfa_final_states(@automaton, @final_states), @initial_state)
  end
  
  def nfa_automaton(old_automaton, alphabet)
	nfa_states = old_automaton.keys.map{|state| [state, transitions(state, alphabet, old_automaton)]}
	Hash[nfa_states]
  end

  def nfa_final_states(automaton, final_states)
	( automaton.keys.select{|state| ! ( eclose(state,automaton) & final_states ).empty? } + final_states ).uniq		
  end	

end   


