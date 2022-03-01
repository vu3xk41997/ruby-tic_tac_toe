# create Display
module Display
    def display_intro
        "Time for some tic-tac-toe!"
    end

    def display_name_prompt(number)
        "What's your name, player ##{number}?"
    end

    def display_marker_prompt
        "Pick 1 alphabet (A-Z) to represent youself."
    end

    def display_unavailable_marker(used_alphabet)
        "It cannot be #{used_alphabet}"
    end

    def display_input_error
        "\e[31mInvalid input, please try again.\e[0m"
    end

    def display_player_turn(name, marker)
        "#{name}, enter 1-9 to place your #{marker}."
    end

    def display_winner(player)
        "#{player} is the winner!"
    end

    def display_tie
        "It's a tie."
    end
end

# create Game
class Game

    include Display

    attr_reader :player_1, :player_2, :board, :current_player
    def initialize
        @board = Board.new
        @game_over = false
        @player_1 = nil
        @player_2 = nil
        @current_player = nil
    end

    def play
        game_set_up
        board.show_board
        player_turns
        final
    end

    def create_player(number, used_alphabet_marker = nil)
        puts display_name_prompt(number)
        name = gets.chomp
        marker = marker_input(used_alphabet_marker)
        Player.new(name, marker)
    end

    def turn(player)
        available_position = turn_input(player)
        board.update_board(available_position - 1, player.marker)
        board.show_board
    end

    private
    def game_set_up
        puts display_intro
        @player_1 = create_player(1)
        @player_2 = create_player(2, player_1.marker)
    end

    def marker_input(used_alphabet)
        player_marker_prompts(used_alphabet)
        input = gets.chomp
        if input.match?(/[^0-9]$/) && input != used_alphabet
            return input
        end
        puts display_input_error
        marker_input(used_alphabet)
    end

    def player_marker_prompts(used_alphabet)
        puts display_marker_prompt
        if used_alphabet
            puts display_unavailable_marker(used_alphabet)
        end
    end

    def player_turns
        @current_player = player_1
        until board.full?
            turn(current_player)
            break if board.game_over?
            @current_player = switch_current_player
        end
    end

    def turn_input(player)
        puts display_player_turn(player.name, player.marker)
        number = gets.chomp.to_i
        if board.valid_move?(number)
            return number
        end
        puts display_input_error
        turn_input(player)
    end

    def switch_current_player
        if current_player == player_1
            player_2
        else
            player_1
        end
    end

    def final
        if board.game_over?
            puts display_winner(current_player.name)
        else
            puts display_tie
        end
    end
end

# create Board
class Board
    attr_reader :available_position

    @@winning_possibility = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], 
        [0, 3, 6], [1, 4, 7], [2, 5, 8], 
        [0, 4, 8], [2, 4, 6]
    ].freeze

    def initialize
        @available_position = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end
    
    def show_board
        puts "| #{available_position[0]} | #{available_position[1]} | #{available_position[2]} |"
        puts " ---+---+--- "
        puts "| #{available_position[3]} | #{available_position[4]} | #{available_position[5]} |"
        puts " ---+---+--- "
        puts "| #{available_position[6]} | #{available_position[7]} | #{available_position[8]} |"
    end

    def update_board(number, marker)
        @available_position[number] = marker
    end

    def valid_move?(number)
        available_position[number - 1] == number
    end

    def full?
        available_position.all? {|square| square =~ /[^0-9]/}
    end

    def game_over?
        @@winning_possibility.any? do |possibility|
            [available_position[possibility[0]], available_position[possibility[1]], available_position[possibility[2]]].uniq.length == 1
        end
    end
end


# create Player
class Player
    attr_reader :name, :marker
    def initialize(name, marker)
        @name = name
        @marker = marker
    end
end


# main
def play_tic_tac_toe
    game = Game.new
    game.play
    repeat_game
end

def repeat_game
    puts "Play again? (Y/N)"
    repeat_input = gets.chomp.upcase
    if repeat_input == 'Y'
        play_tic_tac_toe
    else
        puts "See you!"
    end
end

play_tic_tac_toe