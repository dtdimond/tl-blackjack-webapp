require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

#Before 
before do
  @show_hit_stay_buttons = true
  @dealers_turn = false
  @show_play_again_btns = false
end

#******* Routes *********

#Starting point - go to name if not set, else go to game.
get '/' do
  if session[:name] == nil
    redirect '/name'
  else
    redirect '/game'
  end
end

#Show name page to allow to login.
get '/name' do
  erb :get_name
end

#Logout session - go back to starting point.
get '/logout' do
  session[:name] = nil
  redirect '/'
end

#Update name - go to game route.
post '/game' do
  if params[:username].empty?
    @error = "Name required!"
    halt erb(:get_name)
  end

  session[:name] = params[:username]
  redirect '/game'
end

#Start game
get '/game' do
  initialize_game
  check_player_bust_blackjack
  erb :game
end

#Player hits
post '/game/hit/player' do
  session[:player_hand] << session[:deck].pop
  check_player_bust_blackjack
  erb :game
end

#Player stays
post '/game/stay/player' do
  @success = "You stay."
  @show_hit_stay_buttons = false
  erb :game
end

#Start dealer turn
post '/game/dealer_start' do
  @dealers_turn = true
  @show_hit_stay_buttons = false
  check_dealer_bust_blackjack
  erb :game
end

post '/game/hit/dealer' do 
  @dealers_turn = true
  @show_hit_stay_buttons = false

  if dealer_stay?
    redirect '/game/who_won'
  else
    session[:dealer_hand] << session[:deck].pop
    check_dealer_bust_blackjack
  end
  erb :game
end

get '/game/who_won' do
  if get_score(session[:player_hand]) > get_score(session[:dealer_hand])
    @success = "Dealer stays with a #{get_score(session[:dealer_hand])}. You win!"
  else
    @error = "Dealer stays with a #{get_score(session[:dealer_hand])}. You lose."
  end

  @show_play_again_btns = true
  erb :game
end


#********** Helpers ************
helpers do
 def get_card_image(card)
   if card == "facedown"
     return "<img src='/images/cards/cover.jpg'>"
   end

   suit = card[0]
   value = card[1].to_s.downcase
   return "<img src='/images/cards/" + suit.to_s + "_" + value.to_s + ".jpg'>"
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

  def check_player_bust_blackjack
    if get_score(session[:player_hand]) > 21
      @error = "Sorry, you've busted!"
      @show_hit_stay_buttons = false
      @show_play_again_btns = true
    elsif get_score(session[:player_hand]) == 21
      @success = "Blackjack! You win!"
      @show_hit_stay_buttons = false
      @show_play_again_btns = true
    end
  end

  def check_dealer_bust_blackjack
    if get_score(session[:dealer_hand]) > 21
      @success = "Dealer bust! You've won!"
      @show_play_again_btns = true
    elsif get_score(session[:dealer_hand]) == 21
      @error = "Sorry, dealer hit blackjack. You lose."
      @show_play_again_btns = true
    end
  end

  def dealer_stay?
    if get_score(session[:dealer_hand]) <= 16
      return false
    else
      return true
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

