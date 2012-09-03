# encoding: utf-8 
# teste de github
class Conversor
  attr_reader :automaton

  def initialize(automaton = {}, alphabet = [], final_states = [], initial_state)
    @automaton = automaton                     
    @alphabet = alphabet 
    @initial_state = initial_state
    @final_states = final_states
  end                     
  
  def eclose(state, states=@automaton)  
    if (state == 'ø' || state == :ø)
       return ['ø']
    end
    resultant_states = [] 
    resultant_states << state.to_s
    resultant_states << states[state.to_sym]['']   
    resultant_states = resultant_states.flatten
    resultant_states.delete("ø")          
    resultant_states.uniq
  end
  
  def to_dfa
     dfa = {}                   
     new_initial_state = eclose(@initial_state)                                                          
     insert_new_state(dfa, array_to_hash_symbol(new_initial_state))    
     dfa
  end  
  
  def insert_new_state(hash, state)

    transitions = {}

    @alphabet.select {|item| item != ''}.each do |symbol|
      next_states = []
      state.to_s.split('_').each do |char|       
        next_states << @automaton[char.to_sym][symbol]
      end    
      eclose_next_states = []
      next_states.flatten.each do |next_state|
         eclose_next_states << eclose(next_state)
      end    
      transitions[symbol] = eclose_next_states.flatten.sort.uniq
      if transitions[symbol].count != 1
        remove_empty_states(transitions[symbol])
      end
      new_symbol = array_to_hash_symbol(transitions[symbol])    
    end

    hash[state] = transitions

    transitions.each_pair do |key, value|
      if(!hash.has_key?(array_to_hash_symbol(value)))
        insert_new_state(hash, array_to_hash_symbol(value))
      end
    end

  end
  
  def array_to_hash_symbol(array)
      array.join("_").to_sym
  end
  
  def remove_empty_states(array)
    array.delete('ø')
  end

  def to_nfa
	nfa_alphabet = @alphabet.select{|symbol| symbol!=''}
	Conversor.new(nfa_automaton(@automaton, nfa_alphabet), nfa_alphabet, nfa_final_states(@automaton, @final_states), @initial_state)
  end

  def nfa_final_states(automaton, final_states)
	automaton.keys.select{|state| ( eclose(state,automaton) & final_states ).size>0 }.concat(final_states).uniq		
  end	
  
  def nfa_automaton(old_automaton, alphabet)
	nfa_states = old_automaton.keys.map{|state| [state, nfa_transitions(old_automaton, alphabet , state)]}
	Hash[nfa_states]
  end

  def nfa_transitions(automaton, alphabet , state)
	transitions = alphabet.map{|symbol| nfa_transition(automaton, symbol, state)}
	Hash[transitions]
  end

  def nfa_transition(automaton, symbol, state)
	reached_states = eclose(state, automaton).map{|state| state.to_sym }.flat_map{|state| automaton[state][symbol]}.map{|state| state.to_sym }.flat_map{|state| eclose(state, automaton)}.uniq
	[symbol, remove_empty_states_when_there_are_many_states(reached_states)]
  end

  def remove_empty_states_when_there_are_many_states(states)
    	(states.size>1)? states.select{|state| state!='ø'} : states
  end

end   


