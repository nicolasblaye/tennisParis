require 'rubygems'
require 'highline/import'
require 'unirest'
require 'io/console'
require 'logger'

## A class to store the session token and some url
class TennisSession
  def initialize
    @logger = Logger.new(STDOUT)
    @index_address = 'https://teleservices.paris.fr/srtm/jsp/web/index.jsp'
    @auth_address = 'https://teleservices.paris.fr/srtm/authentificationConnexion.action'
    @init_query_address = 'https://teleservices.paris.fr/srtm/reservationCreneauInit.action'
    @query_address = 'https://teleservices.paris.fr/srtm/reservationCreneauListe.action'
    @reservation_address = 'https://teleservices.paris.fr/srtm/reservationCreneauReserver.action'
    @reservation_validation = 'https://teleservices.paris.fr/srtm/ReservationCreneauValidationForm.action'

    @cookie = auth_cookie
  end

  def auth_cookie
    @logger.info('get Auth Cookie')
    response = Unirest.get(@index_address)
    @cookie = response.headers[:set_cookie][0]
  end

  def credentials
    login = ask 'login'
    puts 'password'
    password = STDIN.noecho(&:gets).chomp
    [login, password]
  end

  def connect
    @logger.info("Connecting to user #{@login} ...")
    headers = { 'Accept' => 'text/html', 'Cookie' => @cookie }
    login, password = credentials
    parameters = { login: login, password: password }
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
    @logger.info('Requesting the tennis courts page 1')
    Unirest.post @query_address,
                 headers: headers,
                 parameters: query_parameters
  end

  def get_search_page(link)
    headers = {
      'Accept' => 'text/html',
      'Cookie' => @cookie
    }
    page = link.split('&')
               .select { |param| param.include?('d-41734-p') }[0]
               .split('=')[-1].to_i
    @logger.info("Getting page #{page} ")
    Unirest.get link, headers: headers
  end

  def reservation_page(key)
    headers = {
      'Accept' => 'text/html',
      'Cookie' => @cookie
    }
    Unirest.post @reservation_address,
                 headers: headers,
                 parameters: { cle: key }
  end

  def captcha_getter
    headers = {
      'Accept' => 'image/jpeg',
      'Cookie' => @cookie
    }
    @logger.info('Getting a new captcha')
    captcha_url = 'https://teleservices.paris.fr/srtm/ImageCaptcha'
    Unirest.get captcha_url, headers: headers
  end
  
  def validate_reservation(captcha)
    headers = {
      Accept: 'text/html',
      Cookie: @cookie,
      jcaptcha_reponse: captcha,
      valider: 'ENREGISTRER'
    }
    Unirest.post @reservation_validation, headers: headers
  end
end