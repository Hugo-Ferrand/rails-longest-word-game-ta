require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = VOWELS
    @letters += (('A'..'Z').to_a - VOWELS).sample(5)
    @letters.shuffle!
    # https://www.rubyguides.com/2015/03/ruby-random/
    # => Array of letters
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase
    included = included?(@word, @letters)
    english = english_word?(@word)
    not_english = !english_word?(@word)
    if included & english
      @answer = "Congratulations! #{@word} is a valid English word"
    elsif included & not_english
      @answer = "Sorry but #{@word} does not seem to be a valid English word..."
    else # Pas inclus et pas Anglais
      @answer = "Sorry but #{@word} cant' be built out of #{@letters}"
    end
  end

  private

  def included?(word, letters) #("minee", [A, B, C, D, E, F, G, H, I, J])
    word.chars.all? do |letter|
    # .chars => Return an Array of characters of a string => [M,I,N,E,E]
    # .all?  => Je vérifie que chaque characters de l'Array donc M puis I puis N puis E puis E
    word.count(letter) <= letters.count(letter)
    # Je compte le nb de A dans [M,I,N,E, E]
    # ...
    # Je compte le nb de E dans [M,I,N,E, E] = 2
    # Je vérifie que ce nb est <= au nb de fois où la lettre appararaît ds lettres (au nb de fois où E apparaît dans [A, B, C, D, E, F, G, H, I, J])
    # english_word? vrai si word.chars.all? vrai si <= vrai
    end
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
