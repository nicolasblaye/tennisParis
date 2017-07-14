require 'rubygems'
require 'highline/import'
require 'unirest'
require 'io/console'
require 'logger'

## A class to store the session token and some url
class TennisSession
  def initialize()
    @logger = Logger.new(STDOUT)
    @index_address = 'https://teleservices.paris.fr/srtm/jsp/web/index.jsp'
    @cookie = NIL
    @research_cookie = NIL
    @auth_address = 'https://teleservices.paris.fr/srtm/authentificationConnexion.action'
    @init_query_address = 'https://teleservices.paris.fr/srtm/reservationCreneauInit.action'
    @query_address = 'https://teleservices.paris.fr/srtm/reservationCreneauListe.action'
    @password = NIL
    @login = NIL

    get_auth_cookie
    get_credentials
    # @base_headers = {
    #     'Connection' => keep-alive,
    #     'Origin' => 'https://teleservices.paris.fr',
    #     'Upgrade-Insecure-Requests' => 1,
    #     'Content-Type' => 'application/x-www-form-urlencoded',
    #     'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    #     'Referer' => 'https://teleservices.paris.fr/srtm/reservationCreneauInit.action'
    # }
  end

  def get_auth_cookie()
    @logger.info("get Auth Cookie")
    response = Unirest.get(@index_address)
    @cookie = response.headers[:set_cookie][0]
  end

  def get_credentials()
    @login = ask 'login'
    puts 'password'
    @password = STDIN.noecho(&:gets).chomp
  end

  def connect()
    @logger.info("Connecting to user #{@login} ...")
    headers = { 'Accept' => 'text/html', 'Cookie' => @cookie }
    parameters = { login: @login, password: @password }
    Unirest.post @auth_address,
                 headers: headers,
                 parameters: parameters
  end

  def search_query(query_parameters)
    @logger.info('Searching for a tennis court...')
    @logger.info('Initializing the search...')
    headers = {
        'Accept' => 'text/html',
        'Cookie' => @cookie
    }
    Unirest.get @init_query_address, headers: headers
    @logger.info('Requesting the tennis courts')
    Unirest.post @query_address,
                 headers: headers,
                 parameters: query_parameters
  end
end