require 'singleton'

class Piece

  def initialize(color = nil, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def get_moves
    moves(@move_dir, @pos)
  end

end

module SlidingPiece
  def moves(dir ,pos)
    moves = []
    row, col = pos
    case dir
    when "horiz/vert"
      (0..7).each do |idx|
        moves << [row, idx] unless col == idx
        moves << [idx, col] unless row == idx
      end
    when "diag"
      (1..7).each do |diff|
        moves << [row + diff, col + diff]
        moves << [row - diff, col - diff]
        moves << [row + diff, col - diff]
        moves << [row - diff, col + diff]
      end
      moves.select! do |coords|
        coords.all? { |coord| coord.between?(0,7) }
      end
    when "both"
      (0..7).each do |idx|
        moves << [row, idx] unless col == idx
        moves << [idx, col] unless row == idx
      end
      (1..7).each do |diff|
        moves << [row + diff, col + diff]
        moves << [row - diff, col - diff]
        moves << [row + diff, col - diff]
        moves << [row - diff, col + diff]
      end
      moves.select! do |coords|
        coords.all? { |coord| coord.between?(0,7) }
      end
    end
    moves
  end

end

module SteppingPiece
  def moves(pos, diffs)
    moves = []
    row, col = pos

    moves << [row + diffs[0], col + diffs[1]]
    moves << [row + diffs[0], col - diffs[1]]
    moves << [row - diffs[0], col + diffs[1]]
    moves << [row - diffs[0], col - diffs[1]]

    case diffs
    when [1, 2]
      moves << [row + diffs[1], col + diffs[0]]
      moves << [row + diffs[1], col - diffs[0]]
      moves << [row - diffs[1], col + diffs[0]]
      moves << [row - diffs[1], col - diffs[0]]
    when [1, 1]
      moves << [row, col + diffs[1]]
      moves << [row, col - diffs[1]]
      moves << [row + diffs[0], col]
      moves << [row - diffs[0], col]
    end

    moves
  end

end

class Rook < Piece
  include SlidingPiece
  def initialize(color = nil, board, pos)
    @move_dir = "horiz/vert"
    @pos = pos
    @sybol = "R"
    super(color = nil, board, pos)
  end
end

class Bishop < Piece
  include SlidingPiece
  def initialize(color = nil, board, pos)
    @move_dir = "diag"
    @pos = pos
    @symbol = "B"
    super(color = nil, board, pos)
  end
end

class Queen < Piece
  include SlidingPiece
  def initialize(color = nil, board, pos)
    @move_dir = "both"
    @pos = pos
    @symbol = "Q"
    super(color = nil, board, pos)
  end
end

class Knight < Piece
  include SteppingPiece
  def initialize(color = nil, board, pos)
    @pos = pos
    @symbol = "N"
    super(color = nil, board, pos)
  end
end

class King < Piece
  include SteppingPiece
  def initialize(color = nil, board, pos)
    @pos = pos
    @symbol = "K"
    super(color = nil, board, pos)
  end
end

class Pawn < Piece
  include SteppingPiece
  def initialize(color = nil, board, pos)
    @pos = pos
    @symbol = "P"
    super(color = nil, board, pos)
  end
end

class NullPiece
  include Singleton

  def initialize(color = nil)
    @moves = nil
    @color = color
  end

  def to_s

  end

  def empty?

  end
end
