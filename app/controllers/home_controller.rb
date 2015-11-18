require 'securerandom'
require 'fileutils'

class HomeController < ApplicationController

	protect_from_forgery except: :recieve_pdf

  # GET /home
  def index
  	@error = "You didn't set up your environment variable. Please set up your ENV['API_TOKEN'] and come back." if ENV['API_TOKEN'].blank?

  	logger.info request.url
  end

  def generate_pdf

		Hpa.api_token = ENV['API_TOKEN']
		
		id = SecureRandom.uuid
		callback_url = Rails.env.development? ? "http://zeus.effectiva.hr:9001/recieve_pdf/#{id}" : "https://#{request.host}/recieve_pdf/#{id}"
		response = Hpa::Pdf.create(
			:callback => callback_url,
      :html => "<!doctype html><html><head><title></title></head><body>Hello</body></html>"
    )

    logger.info response

		logger.info id
		cookies[:file_id] = id

		respond_to do |format|
			msg = { :status => response }
			format.json  { render :json => msg }
		end
  end

  def recieve_pdf

  	pdf_name = params[:id] + ".pdf"
  	logger.info cookies[:file_id]


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
		
		private_pdf_dir = 'public/uploads/pdf'
		pdf_file_path = [private_pdf_dir, pdf_name].join("/")


		pdf_exists = File.exists? pdf_file_path

  	respond_to do |format|

	    msg = { :status => "ok", :message => pdf_exists ? 'Done' : 'Processing' }

	    format.json  { render :json => msg }
	  end
  end

end
