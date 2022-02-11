# hangman game
class Hangman
  attr_accessor :random_word

  def initialize
    @word_options_array = File.read('google-10000-english-no-swears.txt').split.delete_if { |i| i.length < 5 || i.length > 12 }
    @random_word = @word_options_array.sample
    @game_over = false
    @acceptable_guess = ('a'..'z').to_a
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
    if guess.downcase == 'save'
      end_game
      false
    elsif guess.length > 1 || @acceptable_guess.any?(guess.downcase) == false
      puts 'WARNING: Guess must be a single letter or "save".'
      false
    else
      true
    end
  end

  def guess_correct?(guess, word_array)
    true if word_array.any?(guess)
  end

  def update_word_builder(guess, word_array, word_builder)
    word_array.each_index { |i| word_builder[i] = guess if word_array[i] == guess }
    word_builder
  end

  def win_or_lose(word_array, word_builder, incorrect_guess_array)
    if word_array == word_builder
      puts 'You win! Congrats!'
    elsif incorrect_guess_array.length > 9
      puts "Better luck nect time! The correct word was '#{@random_word}'."
    else
      puts 'See you next time!'
    end
  end

  def game_info(incorrect_guess_array, word_builder)
    puts "2) Past guesses: #{incorrect_guess_array.sort.join(':')}"
    puts "3) You have #{10 - incorrect_guess_array.length} guesses left."
    puts "4) #{word_builder.join('')}"
  end

  def correct?(guess, word_array, word_builder, incorrect_guess_array)
    if guess_correct?(guess, word_array)
      puts '1) Guess is correct.'
      word_builder = update_word_builder(guess, word_array, word_builder)
    elsif incorrect_guess_array.any?(guess)
      puts "1) You have already guessed #{guess}"
    else
      incorrect_guess_array.push(guess)
      puts '1) Guess is not correct.'
    end
  end

  def game_loop
    incorrect_guess_array = []
    word_builder = Array.new(@random_word.length, '_')
    word_array = @random_word.split('')
    welcome
    until word_array == word_builder || incorrect_guess_array.length > 9 || @game_over == true do
      puts 'Please guess a letter.'
      guess = gets.strip
      if valid_guess?(guess)
        correct?(guess, word_array, word_builder, incorrect_guess_array)
        game_info(incorrect_guess_array, word_builder)
      end
    end
    win_or_lose(word_array, word_builder, incorrect_guess_array)
  end
end


game = Hangman.new
game.game_loop
