require 'yaml'

class Game
  attr_accessor :secret_code, :game_results, :hints, :turns
  HINTS = 1
  TURNS = 10

  def initialize
    @secret_code = (1..4).map { rand(1..6) }.join
    @game_results = ""
    @hints = HINTS
    @turns = TURNS
  end

  def verify_guess(guess)
    @turns -= 1
    result = analyze_guess(guess)
    if result.eql? '++++'
      @game_results = 'win'
    elsif @turns == 0
      @game_results = 'lose'
    else
      @game_results = result
    end
    @game_results
  end

  def hint
    return "Hints are over" if @hints <= 0 
    @hint = @secret_code[rand(4)]
    @hints -= 1
    "#{@hint}"
  end

  def save_score(name)
    result = {}
    result[:name] = name 
    result[:secret_code] = @secret_code
    result[:game_result] = @game_results
    result[:used_hints] = HINTS - @hints
    result[:used_attemps] = TURNS - @turns
    result[:date] = Time.now
    File.open('text.yml', 'a') { |f| f.write YAML.dump(result) }
  end

  private
  def analyze_guess(guess)
    result = ''
    code_split =  @secret_code.split('')
    guess.split('').each_with_index do |char, index|
      if char.eql? code_split[index]
        result << "+"
      code_split[index] = nil
      end
    end
    guess.split('').each_with_index do |char, index|
      next if code_split[index] == nil
      if code_split.include? char
      result << '-'
        code_split[code_split.index(char)] = ''
    end
    end
    result
  end
end
