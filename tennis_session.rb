require 'rubygems'
require 'highline/import'
require 'unirest'
require 'io/console'

## A class to store the session token and some url
class TennisSession
  def initialize()
    @index_address = "https://teleservices.paris.fr/srtm/jsp/web/index.jsp"
    @cookie = NIL
    @research_cookie = NIL
    @auth_address = "https://teleservices.paris.fr/srtm/authentificationConnexion.action"
    @query_address = "https://teleservices.paris.fr/srtm/reservationCreneauListe.action"
    @result_pages_address = "https://teleservices.paris.fr/srtm/jsp/web/reservation/reservationCreneauListe.jsp"
    @password = NIL
    @login = NIL

    get_cookie
    get_credentials
    get_research_cookie
  end

  def get_cookie()
    response = Unirest.get(@index_address)
    @cookie = response.headers[:set_cookie][0]
  end

  def get_credentials()
    @login = ask 'login'
    puts 'password'
    @password = STDIN.noecho(&:gets).chomp

  end

  def get_research_cookie()
    Unirest.get @query_address,
                headers: {"Accept" => "text/html", "Cookie" => @cookie},
                parameters: {:login => @login, :password => @password}
  end

  def connect(login, password)
    Unirest.post @auth_address,
                 headers: {"Accept" => "text/html", "Cookie" => @cookie},
                 parameters: {:login => @login, :password => "xxx"}
  end

  def search_query(query_parameters)
    response = Unirest.post @query_address, headers: {"Cookie" => @cookie}, parameters: query_parameters
    return response
    #pages = 1
    #(1..pages).each do |n|
    #	read_result_from_page(n)
    #end

  end

  def read_result_from_page(html)
    return html
  end
end