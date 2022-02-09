# hangman game
class Hangman
  def initialize 
    @word_options_array = File.read('google-10000-english-no-swears.txt').split.delete_if { |i| i.length < 5 || i.length > 12 }
    @random_word = @word_options_array.sample
    @game_over = false
  end

  def end_game
    @game_over = true
  end

  def random_word
    @random_word
  end

  def new_random_word
    @random_word = @word_options_array.sample
  end

  def if_valid_guess(guess)
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

  def game_loop
    incorrect_guess_array = []
    word_builder = []
    word_array = @random_word.split('')
    until word_array == word_builder || incorrect_guess_array.length > 3 || @game_over == true do
      puts 'Please guess a letter.'
      guess = gets.strip
      if if_valid_guess(guess)
        if word_array.any?(guess)
          puts 'present'
        else
          incorrect_guess_array.push(guess)
          puts 'not present'
          puts incorrect_guess_array
        end
      end
    end
  end
end


game = Hangman.new
game.game_loop
