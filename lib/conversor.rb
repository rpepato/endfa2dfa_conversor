# encoding: utf-8 
# teste de github
class Conversor
  
  def initialize(automaton = {}, alphabect = [], final_states = [], initial_state)
    @automaton = automaton                     
    @alphabect = alphabect 
    @initial_state = initial_state.to_sym
    @final_states = final_states
    @new_final_states = []
  end                     
  
  def eclose(state)  
    if (state == 'ø' || state == :ø)
       return ['ø']
    end
    resultant_states = [] 
    resultant_states << state.to_s
    resultant_states << @automaton[state.to_sym]['']   
    resultant_states = resultant_states.flatten
    resultant_states.delete("ø")          
    resultant_states.uniq
  end
  
  def to_dfa
     dfa = {}                   
     @new_initial_state = eclose(@initial_state)                                                          
     insert_new_state(dfa, array_to_hash_symbol(@new_initial_state))    
     dfa
  end  
  
  def initial_state_after_processing
     array_to_hash_symbol(@new_initial_state)
  end   
  
  def final_states_after_processing
    @new_final_states.sort
  end
  
  def insert_new_state(hash, state)

    transitions = {}

    @alphabect.select {|item| item != ''}.each do |symbol|
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

      if (transitions[symbol] - @final_states != transitions[symbol] && 
         !@new_final_states.include?(array_to_hash_symbol(transitions[symbol])))
         @new_final_states << array_to_hash_symbol(transitions[symbol]) 
      end                                                           
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
  
end   
