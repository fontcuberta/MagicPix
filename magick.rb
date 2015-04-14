require 'mini_magick'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'io/console'
require 'pry'
$LOAD_PATH << '.'
require 'magick_logic'

enable :sessions

get '/' do
	if session[:true]
		erb :home
	else
		redirect to('/login')
	end
end

get '/login' do
	erb :login
end

post '/' do
	username = params[:username]
	password = params[:password]
	if session[:true] == true || (Auth.new.login?(username) && Auth.new.found?(username, password))
			session[:true] = true
			erb :home
	else
		erb :login
	end
end

get '/pixmap' do
	if session[:true]
		erb :pixmap
	else
		redirect to('/login')
	end
end

post '/pixmap' do
	#This if exits the post if the session values are invalid or I couldn't upload a picture
	if session[:true] == false || params[:pic] == nil
		status 401
		redirect to("/")
	end
		#temp_img_path gets inside the :pic in hash params (returned from the form in /home) gets the tempfile obj inside pic obj and the path
		temp_img_path = params[:pic][:tempfile].path
		temp_img = MiniMagick::Image.open(temp_img_path)

		temp_img.write "./public/img/"+params[:pic][:filename]
		temp_img.resize "100x100"
		temp_img.write "./public/img/thumbs/"+params[:pic][:filename]
		@images = Dir.entries('./public/img/thumbs/')
		@images = @images.slice(3, @images.length)
		
		erb :pixmap
end

get '/logout' do
	session[:true] = false
	erb :logout
end

