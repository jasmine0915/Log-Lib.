require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/user.rb'
require './models/book.rb'

enable :sessions

get '/' do
  if session[:user]
    
    redirect '/home'
  
  else
  
    erb :index
  
  end
end

get '/signin' do
  erb :sign_in
end

get '/signup' do
  erb :sign_up
end

post '/signin' do
  user = User.find_by(mail: params[:mail])
  
  if user && user.authenticate(params[:password])
    session[:user] = user.id
    
    redirect '/home'
  end
  
  redirect '/'
end
    
post '/signup' do
  @user = User.create(
    mail: params[:mail],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
    )
    
  if @user.persisted?
    session[:user] = @user.id
    
    redirect '/home'
  end
  
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  
  redirect '/'
end

get '/home' do
  if session[:user]
    @books = Book.where(user_id: session[:user])
    erb :home
  else
    redirect '/'
  end
end

post '/createbook' do
  Book.create(
    book_title: params[:book_title],
    user_id: session[:user]
    )
  
  redirect '/home'
end

=begin
get '/api/site' do
  html = Nokogiri::HTML.parse(open(params[:url]))
  title = html.css('title').text
  data = {title: title}
  json data
end
=end