# ./order_interface.rb
require 'net/http'
require 'colorize'
require 'json'
require 'date'
require 'uri'

# Class to get the connection with a third-party API using http requests
class OrderInterface

  ###################
  ### Constructor ###
  ###################

  def initialize(url, path, params, page_number)
    @url_base    = url
    @url_path    = path
    @params      = params
    @page_number = page_number
  end

  ########################
  ### Instance Methods ###
  ########################

  # Instance function to make the http request to the API and get the information and pass to the
  # requestor in this case we just have [GET] handling, we can also have [POST, PUT, PATH, DELETE]
  # and handle the exceptions if the response or some validations are not passing 
  # (Params): []
  # (Returns): [response:Object]
  def get_data
    uri       = URI("#{@url_base}/#{@url_path}")
    uri.query = @params
    use_ssl   = { use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE }
    response  = {}

    Net::HTTP.start(uri.host, uri.port, use_ssl) do |http|
      request  = Net::HTTP::Get.new(uri)
      response = http.request(request)
    end

    raise JSON.parse(response.body)['error'] if !JSON.parse(response.body)['error'].nil?

    raise "page_arg_must_be_integer" if !@page_number.empty? && @page_number.scan(/\d/).join('').to_i == 0

    raise "no_response" if JSON.parse(response.body).nil?

    raise "no_orders_found" if JSON.parse(response.body)['orders'].nil?

    { res: JSON.parse(response.body), status: get_response_status(response) }
  end

  #####################
  ### Class Methods ###
  #####################
  
  # Class function to handle the error type depending on the message
  # passed on the exception
  # (Params): [error_code:String]
  # (Returns): [exception:String]
  def self.handle_error(error_code)
    case error_code.to_sym
    when :unknown_error
      puts "Something went wrong".red
    when :page_arg_must_be_integer
      puts "Page number must be an integer number".red
    when :no_response
      puts "No response data found".red
    when :no_orders_found
      puts "No orders found".red
    else
      puts "#{error_code}".capitalize.red
    end
  end

  private

    # Private function to handle the error type depending on the http response type
    # to create our own response, in case we want to pass the processed information 
    # to other microservices or consumer
    # (Params): [response:Net::HTTPResponse]
    # (Returns): [response_status:Symbol]
    def get_response_status(response)
      case response
      when Net::HTTPSuccess
        :ok
      when Net::HTTPRedirection
        :multiple_choices
      when Net::HTTPNotFound
        :not_found
      when Net::HTTPClientError
        :bad_request
      when Net::HTTPServerError
        :internal_server_error
      else
        :bad_request
      end
    end
end