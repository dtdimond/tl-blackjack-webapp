require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

#Before 
before do
  @show_hit_stay_buttons = true
end

#Routes
get '/' do
  if session[:name] == nil
    redirect '/name'
  else
    redirect '/game'
  end
end

get '/name' do
  erb :get_name
end

post '/game' do
  session[:name] = params[:username]
  redirect '/game'
end

get '/game' do
  initialize_game
  erb :game
end

post '/game/hit/player' do
  session[:player_hand] << session[:deck].pop
  if get_score(session[:player_hand]) > 21
    @error = "Sorry, you've busted!"
    @show_hit_stay_buttons = false
  end
  erb :game
end

post '/game/stay/player' do
  @success = "You stay."
  @show_hit_stay_buttons = false
  erb :game
end

#Helpers
helpers do
  def get_card_image(card)
    suit = card[0]
    value = card[1].to_s.downcase
    
    return "<img src='images/cards/" + suit.to_s + "_" + value.to_s + ".jpg'>"
  end

  def initialize_game
    #init deck
    suits = ["diamonds","clubs","spades","hearts"]
    values = ["Ace",2,3,4,5,6,7,8,9,10,"Jack","Queen","King"]
    session[:deck] = suits.product(values).shuffle!

    #deal hand
    deal_cards
  end

  def deal_cards
    session[:dealer_hand] = []
    session[:player_hand] = []

    2.times do
      session[:player_hand] << session[:deck].pop
      session[:dealer_hand] << session[:deck].pop
    end
  end

  def get_score(hand)
    score = 0

    values = hand.map{|card| card[1]}
    values.each do |val|
      if Array(2..10).include?(val)
        score += val
      elsif ["Jack", "Queen", "King"].include?(val)
        score += 10
      end
    end

    # deal with the aces
    values.count("Ace").times do
      if score + 11 <= 21
        score += 11
      else
        score += 1
      end
    end

    return score
  end
end

