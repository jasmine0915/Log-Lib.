require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/user.rb'
require './models/book.rb'
require './models/content.rb'

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
    @user_id = session[:user]
    @books = Book.where(user_id: @user_id)
#    @contents = Content.where(user_id: @user_id, book_id:)
    erb :home
  else
    redirect '/'
  end
end

get '/create_book' do
  erb :create_book
end

post '/createbook' do
  @booktitle = params[:book_title]
  @userid = session[:user]
  Book.create(
    book_title: @booktitle,
    user_id: @userid
    )
    
  @bookinfo = Book.find_by(book_title: @booktitle, user_id: @userid)
  
=begin
  @urls = params[:url]
  @url_titles = params[:url_title]
  @contents = params[:content]
=end
  
  Content.create(
    user_id: @userid,
    book_id: @bookinfo.id,
    url: params[:url],
    url_title: params[:url_title],
    content: params[:content]
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