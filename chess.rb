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
    until won?
      start_pos = get_pos
      end_pos = get_pos
      p start_pos
      p end_pos
    end
  end

  def get_pos
    curr_pos = nil
    pos = nil
    until curr_pos == @display.cursor.cursor_pos
      # system "clear"
      @display.render
      curr_pos = @display.cursor.get_input
    end
    if empty?(curr_pos)
      puts "that square is empty"
      sleep(1)
    else
      pos = curr_pos
    end
    pos
  rescue OutOfBoundsError
    puts "Careful, you've gone off the grid!"
    sleep(0.5)
    retry
  end

  def won?
    false
  end

  def empty?(pos)
    @board[pos].is_a?(NullPiece)
  end
end


g = Chess.new
g.play
