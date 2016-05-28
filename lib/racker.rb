require 'json'
require_relative 'game'
require 'erb'

class Racker
  WIN = 'win'
  LOSE = 'lose'

  attr_accessor :result

  def self.call(env)
    new(env).response
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
      case @request.path
      when "/" then index
      when "/start" then start
      when "/game" then game
      when "/check_guess" then check_guess
      when "/hint" then hint
      when "/save" then save_result
      when "/about" then about
      else Rack::Response.new("Not Found", 404)
    end
  end

  def index
    Rack::Response.new(render("index"))
  end

  def start
    @@game = Game.new
    redirect_to('game')
  end

  def game
    Rack::Response.new(render("game"))  
  end

  def check_guess 
    @@game.verify_guess(@request.params['guess'])
    redirect_to('game')
  end

  def hint
    Rack::Response.new(@@game.hint)
  end

  def save_result
    @@game.save_score(@request.params['user_name'])
    redirect_to('')
  end

  def about
    Rack::Response.new(render("about"))
  end

  private
  def redirect_to(param) 
    Rack::Response.new do |response|
      response.redirect("/#{param}")
    end
  end

  def render(template)
    path = File.expand_path("../views/game/#{template}.html.erb", __FILE__)
    layout do
      ERB.new(File.read(path)).result(binding)
    end
  end

  def layout
    layout_path = File.expand_path("../views/layouts/layout.html.erb", __FILE__)
    ERB.new(File.read(layout_path)).result(binding)
  end
end