# hangman game
class Hangman
  attr_accessor :random_word

  def initialize
    @word_options_array = File.read('google-10000-english-no-swears.txt').split.delete_if { |i| i.length < 5 || i.length > 12 }
    @random_word = @word_options_array.sample
    @game_over = false
  end

  def end_game
    @game_over = true
  end

  def new_random_word
    @random_word = @word_options_array.sample
  end

  def valid_guess?(guess)
    if guess.downcase == 'save'
      puts 'gameover'
      end_game
      false
    elsif guess.length > 1
      puts 'guess must be a single letter or "save".'
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

  def game_loop
    incorrect_guess_array = []
    word_builder = Array.new(@random_word.length, '_')
    word_array = @random_word.split('')
    until word_array == word_builder || incorrect_guess_array.length > 2 || @game_over == true do
      puts 'Please guess a letter.'
      guess = gets.strip
      if valid_guess?(guess)
        if guess_correct?(guess, word_array)
          puts 'Guess is correct.'
          word_builder = update_word_builder(guess, word_array, word_builder)
          puts word_builder.join('')
        else
          puts 'Guess is not correct.'
        end
      end
    end
  end
end


game = Hangman.new
game.game_loop
