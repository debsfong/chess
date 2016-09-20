require_relative 'piece'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
  end

  def move(start_pos, end_pos)
    if @grid[start_pos].is_a?(NullPiece)
      raise "There is no piece there"
    elsif !valid_move?(start_pos, end_pos)
      raise "That is not a valid move"
    else
      @grid[end_pos] = @grid[start_pos]
      @grid[start_pos] = NullPiece.new
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def in_bounds?(pos)
    pos.all? { |coor| coor.between?(0,7) }
  end

end
