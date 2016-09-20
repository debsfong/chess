require 'colorize'
require_relative 'cursor'
require_relative 'piece'

class Display
  attr_reader :cursor
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    puts "  " + (0..7).to_a.join("  ")
    @board.grid.each_with_index do |row, row_idx|
      print "#{row_idx}"
      row.each_with_index do |square, col_idx|
        pos = [row_idx, col_idx]
        colored = false
        colored = true if pos == @cursor.cursor_pos
        if square.is_a?(Piece)
          print colored ? " #{square.to_s} ".colorize(:background => :blue) : " #{square.to_s} "
        else
          print colored ? "   ".colorize(:background => :blue) : "   "
        end
      end
      puts
    end
  end
end
