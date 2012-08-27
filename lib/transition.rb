# encoding: utf-8
class Transition
  attr_reader :transition_symbol, :destination_state
  
  def initialize(params ={})
    @transition_symbol = params[:when_receive_symbol]
    @destination_state = params[:should_go_to]
  end
end