class WordChainer
  def initialize(dictionary_file_name)
    #need to change array to set
    @dict = []
    File.foreach(dictionary_file_name) do |word|
      @dict << word.chomp
    end
  end
  
  def adjacent_words(word)
    @dict.select! {|dict_word| dict_word.length == word.length}
    adjacent_words = []
    i = 0
    while i < word.length
      temp_word = word[0...i] + word[i+1..-1]
      @dict.each do |dict_word|
        test_word = dict_word[0...i] + dict_word[i+1..-1]
        if temp_word == test_word
          adjacent_words << dict_word
        end
      end
      i += 1
    end
    adjacent_words.uniq
  end
  
  def run(source,target)
    @current_words = [source]
    @all_seen_words = {source => nil}
    until @current_words.empty? || @all_seen_words.has_key?(target)
      @current_words = explore_current_words
    end
  
    build_path(target)
    
  end
  
  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      self.adjacent_words(current_word).each do |adjacent_word|
        unless @all_seen_words.has_key?(adjacent_word)
          new_current_words << adjacent_word
          @all_seen_words[adjacent_word] = current_word
          
        end
      end
    end
    
    new_current_words.each do |word|
      puts "word: #{word}  source: #{@all_seen_words[word]}"
    end
    new_current_words
  end
  
  def build_path(target)
    return "No path exists." if @all_seen_words.has_key?(target) == false

    source = @all_seen_words[target]
    path = [target, source]
    until source == nil
      source = @all_seen_words[source]
      path << source
    end
    
    p path[0..-2]
  end
end

x = WordChainer.new('dictionary.txt')

x.run('market', 'toilet')