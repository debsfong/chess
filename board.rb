require_relative 'piece'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    initialize_pieces
  end

  def valid_move?(start_pos, end_pos)
    moves = self[start_pos].get_moves
    moves.include?(end_pos)
  end

  def move(start_pos, end_pos)
    if self[start_pos].is_a?(NullPiece)
      raise "There is no piece there"
    elsif !valid_move?(start_pos, end_pos)
      raise "That is not a valid move"
    else
      self[end_pos] = self[start_pos]
      self[end_pos].pos = end_pos

      self[start_pos] = NullPiece.new
    end
  end

  def initialize_pieces
    # pawns
    (0..7).each_with_index do |square, col_idx|
      self[[1, col_idx]] = Pawn.new(:black, self, [1, col_idx] )
    end
    (0..7).each_with_index do |square, col_idx|
      self[[6, col_idx]] = Pawn.new(:white, self, [6, col_idx] )
    end
    #rooks
    black_rooks = [[0,0], [0,7]]
    white_rooks = [[7,0], [7,7]]
    black_rooks.each { |pos| self[pos] = Rook.new(:black, self, pos) }
    white_rooks.each { |pos| self[pos] = Rook.new(:white, self, pos) }
    #knights
    black_knights = [[0,1], [0,6]]
    white_knights = [[7,1], [7,6]]
    black_knights.each { |pos| self[pos] = Knight.new(:black, self, pos) }
    white_knights.each { |pos| self[pos] = Knight.new(:white, self, pos) }
    #bishops
    black_bishops = [[0,2], [0,5]]
    white_bishops = [[7,2], [7,5]]
    black_bishops.each { |pos| self[pos] = Bishop.new(:black, self, pos) }
    white_bishops.each { |pos| self[pos] = Bishop.new(:white, self, pos) }
    #queens
    self[[0, 3]] = Queen.new(:black, self, [0, 3])
    self[[7, 3]] = Queen.new(:white, self, [7, 3])
    #kings
    self[[0, 4]] = King.new(:black, self, [0, 4])
    self[[7, 4]] = King.new(:white, self, [7, 4])
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
