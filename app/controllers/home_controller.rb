require 'securerandom'
require 'fileutils'

class HomeController < ApplicationController

	protect_from_forgery except: :recieve_pdf

  # GET /home
  def index
  	@error = "You didn't set up your environment variable. Please set up your ENV['API_TOKEN'] and come back." if ENV['API_TOKEN'].blank?
  end

  def generate_pdf

		Hpa.api_token = ENV['API_TOKEN']
		
		id = SecureRandom.uuid
		callback_url = "#{request.base_url}/recieve_pdf/#{id}"
		response = Hpa::Pdf.create(
			:callback => callback_url,
      :url => "#{request.base_url}/example.html"
    )

		cookies[:file_id] = id

		respond_to do |format|
			msg = { :status => response }
			format.json  { render :json => msg }
		end
  end

  def recieve_pdf

  	pdf_name = params[:id] + ".pdf"

		private_pdf_dir = 'public/uploads/pdf'
		pdf_file_path = [private_pdf_dir, pdf_name].join("/")
		FileUtils.mkdir_p private_pdf_dir


  	file = params[:file]
   	File.open(pdf_file_path, "wb") do |f|
   	  f.write file.read
   	end

   	render text: 'ok'

  end

  def check

		pdf_name = params[:id] + ".pdf"
		
		pdf_file_path = ['public/uploads/pdf', pdf_name].join("/")

		pdf_exists = File.exists? pdf_file_path

  	respond_to do |format|
	    msg = { :status => "ok", :message => pdf_exists ? { status: 'Done', url: "#{request.base_url}/uploads/pdf/#{pdf_name}"} : 'Processing' }
	    format.json  { render :json => msg }
	  end
  end

end
