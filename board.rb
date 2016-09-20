require_relative 'piece'
require_relative 'display'

class NoPieceError < StandardError
end

class InvalidMoveError < StandardError
end

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    @display = Display.new(self)
    initialize_pieces
  end

  def valid_move?(start_pos, end_pos)
    moves = self[start_pos].get_moves
    moves.include?(end_pos)
  end

  def move
    begin
      start_pos = get_pos
      raise NoPieceError.new if self[start_pos].is_a?(NullPiece)
      puts "Where would you like to move to?"
    rescue NoPieceError
      puts "There is no piece there"
      retry
    end

    begin
      end_pos = get_pos
      raise InvalidMoveError.new if !valid_move?(start_pos, end_pos)
    rescue InvalidMoveError
      puts "That is not a valid move"
      retry
    end

    self[end_pos] = self[start_pos]
    self[end_pos].pos = end_pos

    self[start_pos] = NullPiece.instance
  end

  def get_pos
    curr_pos = nil
    until curr_pos == @display.cursor.cursor_pos
      # system "clear"
      @display.render
      curr_pos = @display.cursor.get_input
    end
    curr_pos
  rescue OutOfBoundsError
    puts "Careful, you've gone off the grid!"
    sleep(0.5)
    retry
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
