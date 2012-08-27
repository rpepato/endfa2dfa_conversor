# encoding: utf-8
class Automaton
  attr_reader :states
  
  def initialize(states)
    @states = states
  end
  
  def eclose(state)
    e =[]
    e << state.to_sym
    sub = @states.first {|symbol| symbol.name == state.to_sym}
    j = sub.transitions.select {|transition| transition.transition_symbol.to_s.empty?}.collect! {|transition| transition.destination_state}
    p j.destination_state
    
  end
  
  
  
end