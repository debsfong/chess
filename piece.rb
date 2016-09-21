require 'singleton'
require 'colorize'

class Piece
  attr_accessor :pos
  attr_reader :color
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def get_path(start_pos, end_pos)
    get_moves
  end

  def to_s
    @symbol
  end

end

module PawnPiece
  def get_path(start_pos, end_pos)
    []
  end

  def get_moves
    moves(@pos)
  end

  def moves(pos)
    row, col = pos
    moves = []

    case @color
    when :black
      moves << [row + 1, col] if @board[[row + 1, col]].is_a?(NullPiece)
      [[row + 1, col -1], [row + 1, col + 1]].each do |pos|
        moves << pos unless @board[pos].is_a?(NullPiece)
      end
    when :white
      moves << [row - 1, col] if @board[[row - 1, col]].is_a?(NullPiece)
      [[row - 1, col -1], [row - 1, col + 1]].each do |pos|
        moves << pos unless @board[pos].is_a?(NullPiece)
      end
    end

    moves.select! do |coords|
      coords.all? { |coord| coord.between?(0,7) }
    end

    moves
  end
end

module SlidingPiece

  def get_path(start_pos, end_pos)
    moves = get_moves
    path = []
    case
    when start_pos[0] == end_pos[0] # horizontal
      moves.select! { |move| move[0] == start_pos[0] }.sort
      moves.reverse if start_pos[1] > end_pos[1]
      moves.each do |move|
        break if move[1] == end_pos[1]
        path << move
      end
    when start_pos[1] == end_pos[1] # vertical
      moves.select! { |move| move[1] == start_pos[1] }.sort
      moves.reverse if start_pos[0] > end_pos[0]
      moves.each do |move|
        break if move[0] == end_pos[0]
        path << move
      end
    else
      path = get_path_diag(start_pos, end_pos, moves)
    end
    path
  end

  def get_path_diag(start_pos, end_pos, moves)
    case
    when start_pos[0] > end_pos[0]
      moves.reject { |pos| pos[0] > start_pos[0] }
      moves.reject { |pos| pos[0] < end_pos[0] }
    when start_pos[0] < end_pos[0]
      moves.reject { |pos| pos[0] < start_pos[0] }
      moves.reject { |pos| pos[0] > end_pos[0] }
    end

    case
    when start_pos[1] > end_pos[1]
      moves.reject { |pos| pos[1] > start_pos[1] }
      moves.reject { |pos| pos[1] < end_pos[1] }
    when start_pos[1] < end_pos[1]
      moves.reject { |pos| pos[1] < start_pos[1] }
      moves.reject { |pos| pos[1] > end_pos[1] }
    end

    moves
  end

  def get_moves
    moves(@pos, @move_dir)
  end

  def moves(pos, dir)
    moves = []
    row, col = pos
    case dir
    when "horiz/vert"
      moves += horiz_vert_moves(pos)
    when "diag"
      moves += diag_moves(pos)
    when "both"
      moves += horiz_vert_moves(pos)
      moves += diag_moves(pos)
    end
    moves
  end

  def horiz_vert_moves(pos)
    moves = []
    row, col = pos
    (0..7).each do |idx|
      moves << [row, idx] unless col == idx
      moves << [idx, col] unless row == idx
    end
    moves
  end

  def diag_moves(pos)
    moves = []
    row, col = pos
    (1..7).each do |diff|
      moves << [row + diff, col + diff]
      moves << [row - diff, col - diff]
      moves << [row + diff, col - diff]
      moves << [row - diff, col + diff]
    end
    moves.select! do |coords|
      coords.all? { |coord| coord.between?(0,7) }
    end
    moves
  end
end

module SteppingPiece
  def get_path(start_pos, end_pos)
    [] # temporary
  end
  def get_moves
    moves(@pos, @diff)
  end

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
    moves.select! do |coords|
      coords.all? { |coord| coord.between?(0,7) }
    end
    moves
  end
end

class Rook < Piece
  include SlidingPiece
  def initialize(color, board, pos)
    @move_dir = "horiz/vert"
    @pos = pos
    case color
    when :white
      @symbol = "\u2656".encode('utf-8')
    when :black
      @symbol = "\u265C".encode('utf-8')#.colorize(:yellow)
    end
    super(color, board, pos)
  end
end

class Bishop < Piece
  include SlidingPiece
  def initialize(color, board, pos)
    @move_dir = "diag"
    @pos = pos
    case color
    when :white
      @symbol = "\u2657".encode('utf-8')
    when :black
      @symbol = "\u265D".encode('utf-8').colorize(:yellow)
    end
    super(color, board, pos)
  end
end

class Queen < Piece
  include SlidingPiece
  def initialize(color, board, pos)
    @move_dir = "both"
    @pos = pos
    case color
    when :white
      @symbol = "\u2655".encode('utf-8')
    when :black
      @symbol = "\u265B".encode('utf-8').colorize(:yellow)
    end
    super(color, board, pos)
  end
end

class Knight < Piece
  include SteppingPiece
  def initialize(color, board, pos)
    @pos = pos
    @diff = [1, 2]
    case color
    when :white
      @symbol = "\u2658".encode('utf-8')
    when :black
      @symbol = "\u265E".encode('utf-8').colorize(:yellow)
    end
    super(color, board, pos)
  end
end

class King < Piece
  include SteppingPiece
  def initialize(color, board, pos)
    @pos = pos
    @diff = [1, 1]
    case color
    when :white
      @symbol = "\u2654".encode('utf-8')
    when :black
      @symbol = "\u265A".encode('utf-8').colorize(:yellow)
    end
    super(color, board, pos)
  end
end

class Pawn < Piece
  include PawnPiece
  def initialize(color, board, pos)
    @pos = pos
    @has_moved = false
    case color
    when :white
      @symbol = "\u2659".encode('utf-8')
    when :black
      @symbol = "\u265F".encode('utf-8').colorize(:yellow)
    end
    super(color, board, pos)
  end
end

class NullPiece
  include Singleton
  attr_reader :color

  def initialize(color = nil)
    @moves = nil
    @color = nil
  end

  def to_s
    "   "
  end

end
