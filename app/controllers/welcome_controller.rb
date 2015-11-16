class WelcomeController < ApplicationController

  # GET /welcome
  def index
  	puts 'TOKEN ' + env['API_TOKEN'].to_s
  end

  def about
  	
  end

end
