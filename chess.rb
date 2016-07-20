class Board 
	
	attr_accessor :position, :board 
	
    def initialize
    	arr = []
    	8.times { arr << ([nil] * 8)}
    	@board = arr 
    end
    
    def board 
    	@board
    end 
    
    def empty?(square)
    	if self.board[square[0]][square[1]] != nil 
    		return false
    	end 
    end
    
    
    def setup
    	arr = []
    	rook1 = Rook.new([0,0], "white")
    	knight1 = Knight.new([1,0], "white")
    	bishop1 = Bishop.new([2,0], "white")
    	queen = Queen.new([3,0] , "white")
    	king = King.new([4,0], "white")
    	bishop2 = Bishop.new([5,0], "white")
    	knight2 = Knight.new([6,0], "white")
    	rook2 = Rook.new([7,0] , "white")
    	arr.push(rook1,knight1,bishop1,queen,king,bishop2,knight2,rook2)
    	arr.each {|element| self.put_on_board(element)}
    	arr = []
    	b_rook1 = Rook.new([0,7], "black")
    	b_knight1 = Knight.new([1,7], "black")
    	b_bishop1 = Bishop.new([2,7], "black")
    	b_queen = Queen.new([3,7], "black")
    	b_king = King.new([4,7], "black")
    	b_bishop2 = Bishop.new([5,7], "black")
    	b_knight2 = Knight.new([6,7], "black")
    	b_rook2 = Rook.new([7,7], "black")
    	arr.push(b_rook1,b_knight1,b_bishop1,b_queen,b_king,b_bishop2,b_knight2,b_rook2)
    	arr.each {|element| self.put_on_board(element)}
    	self.board.each_with_index do |row,index1|
    		row.each_with_index do |element, index2|
    			if index2 == 1 
    				self.put_on_board(Pawn.new([index1,index2] , "white"))
    			elsif index2 == 6
    				self.put_on_board(Pawn.new([index1,index2] , "black"))
    			end
    		end 
    	end 
    			
    end 
   
    
    def display_board
    	printed_board = []
    	@board.each do |row|
    		row.each do |element|
    			if element.is_a?(Pawn)
    				element = :P
    			elsif element.is_a?(King)
    				element = :K 
    			elsif element.is_a?(Queen)
    				element = :Q 
    			elsif element.is_a?(Knight)
    				element = :N 
    			elsif element.is_a?(Bishop)
    				element = :B 
    			elsif element.is_a?(Rook)
    				element = :R 
    			end 
    			printed_board << element 
    		end 
    	end 
    	printed_board = printed_board.each_slice(8).to_a
    	printed_board.each do |rows|
    		puts rows.to_s 
    	end 
    end 
    
    
    def put_on_board(piece)
    	@board[piece.position[0]][piece.position[1]] = piece 
    end 
   

end 

class Piece 
	
	attr_accessor :board, :current_player, :moved
	
	def initialize(position, color) 
		@position = position
		@color = color 
		@moved = false 
	end 
	
	def color 
		@color
	end 
	
	def was_moved
		@moved = true
	end 
	
	
	def position 
		@position
	end 	
	
	def move(board,space_arr)
		if valid_move?(board, space_arr) == false 
			return false 
		end 
		@position = space_arr
		board.board.each do |row|
			row.collect! do |element|
				element == self ? nil : element 
			end 
		end 
		board.board[@position[0]][@position[1]] = self 
		self.was_moved
	end 
	

end 


class Pawn < Piece 
	def move(board, space_arr)
		if attacking?(board, space_arr) == true 
			capture(board, space_arr)
			return true 
		end 
		if valid_move?(board, space_arr) == false 
			return false
		end 
		capture(board, space_arr)
	end 
	
	
	def attacking?(board, space_arr)
		if self.color == "white"
			if board.board[self.position[0] - 1][self.position[1] + 1] != nil 
				if board.board[self.position[0] - 1][self.position[1] + 1].color == "black" && [self.position[0] - 1, self.position[1] + 1] == space_arr
					return true 
				end 
			end 
			if board.board[self.position[0] + 1][self.position[1] + 1] != nil 
				if board.board[self.position[0] + 1][self.position[1] + 1].color == "black" && [self.position[0] + 1, self.position[1] + 1] == space_arr
					return true 
				end 
			end 
		end 
		if self.color == "black"
			if board.board[self.position[0] - 1][self.position[1] - 1] != nil 
				if board.board[self.position[0] - 1][self.position[1] - 1].color == "white" && [self.position[0] - 1, self.position[1] - 1] == space_arr
					return true 
				end 
			end 
			if board.board[self.position[0] + 1][self.position[1] - 1] != nil 
				if board.board[self.position[0] + 1][self.position[1] - 1].color == "white" && [self.position[0] + 1, self.position[1] - 1] == space_arr
					return true 
				end 
			end 
		end 
		return false 
	end 
	

	def capture(board, space_arr)
		@position = space_arr
		board.board.each do |row|
			row.collect! do |element|
				element == self ? nil : element 
			end 
		end 
		board.board[@position[0]][@position[1]] = self 
		self.was_moved
	end 
	
	
	def valid_move?(board, square)
		if board.empty?(square) == false 
			return false 
		end 
		if self.color == "white"
			return true if self.moved == false && self.position[0] == square[0] && self.position[1] + 2 == square[1]
			unless [self.position[0], self.position[1] + 1] == square
				return false 
			end 
		elsif self.color == "black"
			return true if self.moved == false && self.position[0] == square[0] && self.position[1] - 2 == square[1]
			unless [self.position[0], self.position[1] -1] == square 
				return false 
			end 
		end 
	end 

end 

class King < Piece 	


end 

class Bishop < Piece 

end 
	
	

class Knight < Piece 
	def attacking?(board, square)
		attacked_squares = []
		if [self.position[0] - 2, self.position[1] - 1] != nil 
			attacked_squares << [self.position[0] - 2, self.position[1] - 1]
		end 
		if [self.position[0] - 2, self.position[1] + 1] != nil 
			attacked_squares << [self.position[0] - 2, self.position[1] + 1]
		end 
		if [self.position[0] - 1, self.position[1] - 2] != nil 
			attacked_squares << [self.position[0] - 1, self.position[1] - 2]
		end 
		if [self.position[0] - 1, self.position[1] + 2] != nil
			attacked_squares << [self.position[0] - 1, self.position[1] + 2]
		end 
		if [self.position[0] + 1, self.position[1] - 2] != nil 
			attacked_squares << [self.position[0] + 1, self.position[1] - 2]
		end 
		if [self.position[0] + 1, self.position[1] + 2] != nil 
			attacked_squares << [self.position[0] + 1, self.position[1] + 2]
		end 
		if attacked_squares << [self.position[0] + 2, self.position[1] - 1] != nil
			attacked_squares << [self.position[0] + 2, self.position[1] - 1]
		end 
		if attacked_squares << [self.position[0] + 2, self.position[1] + 1] !=nil 
			attacked_squares << [self.position[0] + 2, self.position[1] + 1]
		end 
		attacked_squares
	end 
	
	def valid_move?(board, square)
		if attacking?(board, square).include?(square) && (board.board[square[0]][square[1]] == nil || board.board[square[0]][square[1]].color != self.color)
			return true 
		else 
			return false 
		end 
	end 
	
	
end 

class Rook < Piece 


end 

class Queen < Piece 


end 

class Player 
	
	def initialize(color)
		@color = color 
	end 
	
	def color 
		@color
	end 
	
	def which_piece?
		puts "Where is the piece you want to move?"
		piece_position = gets.chomp
		piece_position_arr = piece_position.split(",")
		piece_position_arr.map {|element| element.to_i } 
	end 
	
	def to_where? 
		puts "Where do you want to move it?"
		move_string = gets.chomp 
		move_arr = move_string.split(",")
		move_arr.map { |element| element.to_i }
	end 
	

end

class Game 
	
	attr_accessor :current_player
	
	def initialize(player1, player2, board)
		@player1 = player1 
		@player2 = player2 
		@board = board 
		@current_player = player1 
	end 
	
	def current_player
		@current_player 
	end 
	
	def setup
		@board.setup
	end 
	
	
	def board 
		@board 
	end 
	
	def switch_players!
		if current_player == @player1 
			@current_player = @player2 
		elsif current_player == @player2 
			@current_player = @player1 
		end 
	end 
	
	
	def play 
		board.display_board
		while true 
			position_of_piece = current_player.which_piece?
			move_to_square = current_player.to_where?
			piece_to_move = self.board.board[position_of_piece[0]][position_of_piece[1]]
			until piece_to_move.move(self.board, move_to_square) == true && current_player.color == piece_to_move.color
				puts "Please enter a valid move"
				position_of_piece = current_player.which_piece?
				move_to_square = current_player.to_where?
				piece_to_move = self.board.board[position_of_piece[0]][position_of_piece[1]]
			end 
			board.display_board 
			switch_players!
		end 
	end 
	
	
end 


player1 = Player.new("white")
player2 = Player.new("black")
board = Board.new 
game = Game.new(player1, player2, board)
game.setup
game.play




