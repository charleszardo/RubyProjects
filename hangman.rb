class Hangman
  attr_accessor :game_over

  attr_reader :guessed_letters, :secret_word_len

  def initialize(guesser, checker)
    @turns = 0
    @guesser, @checker = guesser, checker
    @game_over = false
    @guessed_letters = {}
  end

  def play
    @secret_word_len = @checker.pick_secret_word
    @guesser.receive_secret_length(@secret_word_len)
    until self.game_over
      board_display
      current_guess = @guesser.guess(@guessed_letters)

      puts "Guess: #{current_guess}"

      before = @guessed_letters
      @guessed_letters[current_guess] = @checker.handle_guess_response(current_guess)
      after = @guessed_letters

      signal = before != after
      board_display

      self.game_over = @checker.check(@turns, signal)
      @turns += 1
    end
    self.reset
  end

  def board_display
    puts ""
    puts "Secret word: #{self.display_word(@secret_word_len)}"
    puts "             #{index_display}"
  end

  def index_display
    idx_display = ""
    self.secret_word_len.times {|n| idx_display += "#{n.to_s} "}
    idx_display
  end

  def display_word(word_len)
    displayed_word = Array.new(word_len, "_")
    @guessed_letters.each do |letter, idx_arr|
      idx_arr.each do |idx|
        displayed_word[idx] = letter
      end
    end
    displayed_word.join(' ')
  end

  def word_guessed?(word)
    word.split('').all? {|letter| guessed_letters.include?(letter)}
  end

  def reset
    self.game_over = false
    @guessed_letters = {}
    @turns = 0
  end
end

class Computer
  DICTIONARY = "dictionary.txt"

  attr_accessor :dict

  attr_reader :current_in_word, :current_guess

  def initialize
    self.create_dict
    @alphabet = ('a'..'z').to_a
    @correct_letters = 0
  end

  def create_dict
    self.dict = []
    File.foreach(DICTIONARY) do |word|
      self.dict << word.chomp
    end
  end

  def guess_word
    self.dict.sample
  end

  def guess(guess_hash)
    self.dictionary_update(guess_hash)
    self.freq_hash_update
    highest_freq = @freq_hash.values.sort.reverse[0]
    guess_array = @freq_hash.find {|k, v| v == highest_freq}
    @alphabet.delete(guess_array[0])
  end

  def dictionary_update(guess_hash)
    guess_hash.each do |letter, indexes|
      indexes.each do |idx|
        @dict = @dict.select {|word| word[idx] == letter}
      end
    end
  end

  def freq_hash_update
    @freq_hash = {}
    @alphabet.each {|letter| @freq_hash[letter] = 0}
    @dict.each do |word|
      word.split('').each do |char|
        if @freq_hash.has_key?(char)
          @freq_hash[char] += 1
        end
      end
    end
  end

  def check(turns, signal)
    if @correct_letters == @secret_word.length
      puts "You've guessed the word in #{turns} turns!"
      return true
    elsif !self.current_in_word
      puts "No #{self.current_guess} in the word."
    end
    return false
  end

  def handle_guess_response(current_guess)
    @current_guess = current_guess
    split_word = @secret_word.split('')
    if split_word.include?(current_guess)
      @current_in_word = true
      indices = split_word.each_index.select{|i| split_word[i] == current_guess}
      @correct_letters += indices.count
      indices
    else
      @current_in_word = false
      return []
    end
  end

  def receive_secret_length(len)
    @dict.select! {|word| word.length == len}
    @secret_length = len
    nil
  end

  def pick_secret_word
    @secret_word = @dict.sample
    @secret_word.length
  end
end

class Human

  attr_reader :guessed_letters

  def initialize
    @guessed_letters = []
  end

  def guess(guess_hash)
    puts "Guess a letter"
    begin
      letter = gets.chomp
      raise RuntimeError.new("Please only select one letter") if letter.length != 1
    rescue RuntimeError => e
      puts e.to_s
      retry
    end
    self.guessed_letters << letter
    letter
  end

  def pick_secret_word
    puts "Think of a word. How many letters is it?"
    Integer(gets.chomp)
  end

  def check(turns, signal)
    if signal
      puts "Has the guesser guessed the correct word?"
      response = gets.chomp
      if response == 'y'
        puts "The guesser got the word in #{turns} turns."
        return true
      end
    end
    false
  end

  def handle_guess_response(letter)
    puts "Is #{letter} in the word? y or n"
    response = gets.chomp
    if response == 'y'
      puts "At what indices does it occur?"
      gets.chomp.split(' ').map {|num| num.to_i}
    else
      return []
    end
  end

  def receive_secret_length(len)
    @secret_length = len
    puts "The secret word is #{len} letters long."
  end
end

if __FILE__ == $PROGRAM_NAME
  comp = Computer.new
  hum = Human.new

  puts "New game"
  puts "Enter 1 to be the guesser, 2 to be the checker."

  choice = Integer(gets.chomp)
  if choice == 1
    hang = Hangman.new(hum,comp)
  else
    hang = Hangman.new(comp,hum)
  end

  hang.play
end