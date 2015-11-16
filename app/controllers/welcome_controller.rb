class WelcomeController < ApplicationController

  # GET /welcome
  def index
  	puts 'TOKEN ' + ENV['API_TOKEN'].to_s
  end

  def about
  	
  end

end
