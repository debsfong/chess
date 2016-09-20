require_relative 'board'

class Chess
  attr_reader :board, :display

  def initialize
    @board = Board.new
  end

  def play
    until won?
      @board.move
    end
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
