# hangman game
require 'json'

class Hangman
  attr_accessor :random_word, :incorrect_guess_array, :word_builder, :word_array

  def initialize
    @word_options_array = File.read('google-10000-english-no-swears.txt').split.delete_if { |i| i.length < 5 || i.length > 12 }
    @random_word = @word_options_array.sample
    @game_over = false
    @acceptable_guess = ('a'..'z').to_a
    @incorrect_guess_array = []
    @word_builder = Array.new(@random_word.length, '_')
    @word_array = @random_word.split('')
  end

  def create_json
    JSON.dump ({
      incorrect_guess_array: @incorrect_guess_array,
      word_builder: @word_builder,
      word_array: @word_array
    })
  end

  def welcome
    puts 'Welcome to hangman. In order to win you must
guess a randomly selected word within 10 turns.
You will guess one letter at a time until either you
know the word or you run out of guesses. Good luck!'
  end

  def end_game
    @game_over = true
  end

  def new_random_word
    @random_word = @word_options_array.sample
  end

  def valid_guess?(guess)
    if guess.downcase == 'exit'
      end_game
      false
    elsif guess.downcase == 'save'
      save_game
      end_game
      false
    elsif guess.length > 1 || @acceptable_guess.any?(guess.downcase) == false
      puts 'WARNING: Guess must be a single letter or "save".'
      false
    else
      true
    end
  end

  def guess_correct?(guess)
    true if @word_array.any?(guess)
  end

  def update_word_builder(guess)
    @word_array.each_index { |i| @word_builder[i] = guess if word_array[i] == guess }
  end

  def win_or_lose
    if @word_array == @word_builder
      puts 'You win! Congrats!'
    elsif @incorrect_guess_array.length > 9
      puts "Better luck nect time! The correct word was '#{@random_word}'."
    else
      puts 'See you next time!'
    end
  end

  def game_info
    puts "2) Past guesses: #{@incorrect_guess_array.sort.join(':')}"
    puts "3) You have #{10 - @incorrect_guess_array.length} guesses left."
    puts "4) #{@word_builder.join('')}"
  end

  def correct?(guess)
    if guess_correct?(guess)
      puts '1) Guess is correct.'
      update_word_builder(guess)
    elsif @incorrect_guess_array.any?(guess)
      puts "1) You have already guessed #{guess}"
    else
      @incorrect_guess_array.push(guess)
      puts '1) Guess is not correct.'
    end
  end

  def save_game
    data = create_json
    puts 'What would you like to name your saved game?'
    id = gets.strip
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    filename = "saved_games/save_#{id}.txt"
    File.open(filename, 'w') do |file|
      file.puts data
    end
    puts "Game has been saved as 'saved_games/save_#{id}.txt'."
  end

  def load_a_save?
    puts 'Would you like to load a past game?'
    answer = gets.strip
    if answer.downcase == 'yes'
      save = choose_save_game
      load_from_json(save)
      puts '1) Game loaded.'
      game_info
    end
  end

  def choose_save_game
    puts 'Which game would you like to load?'
    puts Dir.entries('saved_games')
    answer = gets.strip
    puts "saved_games/#{answer}"
    if File.exist?("saved_games/#{answer}")
      file = File.open("saved_games/#{answer}", 'r')
      contents = file.read
    else
      puts 'File does not exits.'
    end
  end

  def load_from_json(save)
    data = JSON.parse(save)
    @incorrect_guess_array = data['incorrect_guess_array']
    @word_builder = data['word_builder']
    @word_array = data['word_array']
  end

  def load_or_play
    puts 'Would you like to load a saved game? (yes/no)'
    answer = gets.strip
    if answer.downcase == 'yes' 
      string = choose_save_game
      self.load_from_json(string)
    elsif answer.downcase == 'no' 
      puts 'Starting new game...'
    else
      puts 'Please enter "yes" or "no".'
    end
  end

  def game_loop
    welcome
    load_a_save?
    until @word_array == @word_builder || @incorrect_guess_array.length > 9 || @game_over == true do
      puts 'Please guess a letter.'
      guess = gets.strip
      if valid_guess?(guess)
        correct?(guess)
        game_info
      end
    end
    win_or_lose
  end
end


game = Hangman.new
game.game_loop
