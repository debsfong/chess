require_relative 'board'
require_relative 'display'
require_relative 'cursor'

class Chess
  attr_reader :board, :display

  def initialize
    @board = Board.new
    @display = Display.new(@board)
  end

  def play
    while true
      begin
        @display.render
        @display.cursor.get_input
      rescue
        puts "Careful, you've gone off the grid!"
        retry
      end
    end
  end
end

g = Chess.new
g.play
