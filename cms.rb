require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

root = File.expand_path("..", __FILE__) # sets root directory for project

get '/' do
  @file_names = Dir.children(root + "/data/")
  @files = @file_names.map { |file_name| { name: file_name, data: File.new("data/#{file_name}") } }
  
  erb :index, layout: :layout
end

get '/:file_name' do
  file_name = params[:file_name]
  
  if Dir.children(root + "/data/").none?(file_name)
    session[:error] = "#{file_name} does not exist."
    redirect '/'
  else
    file = File.new(root + "/data/#{file_name}")
    
    # headers["Content-Type"] = "text/plain" # this will tell page to display everything as txt (already using erb template so no point)
    @file_data = file.read
  end

  erb :content, layou: :layout
end