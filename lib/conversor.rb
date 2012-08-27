# encoding: utf-8 
class Conversor
  
  def initialize(automaton = {}, alphabect = [], final_states = [], initial_state)
    @automaton = automaton                     
    @alphabect = alphabect 
    @initial_state = initial_state
    @final_states = final_states
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
     new_initial_state = eclose(@initial_state)                                                          
     insert_new_state(dfa, array_to_hash_symbol(new_initial_state))    
     dfa
  end 
  
  def print_dfa
    dfa = to_dfa
    dfa.to_a.sort.each do |item|
      puts item[0]
      item[1].each_pair do |symbol, destination|
        puts "\t#{symbol} => #{destination}"
      end                                       
    end            
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