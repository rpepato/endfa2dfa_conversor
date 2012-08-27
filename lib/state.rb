# encoding: utf-8
class State
  attr_accessor :name, :transitions
  
  def initialize(params = {})
    @initial_state = params[:initial_state]
    @final_state = params[:final_state]
    @name = params[:name]
    @transitions = []
  end
  
  def add_transition(transition)
    @transitions << transition
  end
  
  def initial?
    @initial_state
  end
  
  def final?
    @final_state
  end
  
end