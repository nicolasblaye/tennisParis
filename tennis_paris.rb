#require("nokogiri")
require("unirest")
require("optparse")


## A class to store the session token and some url
class TennisSession
	def initialize()
		@index_address = "https://teleservices.paris.fr/srtm/jsp/web/index.jsp"
		@cookie = get_cookie
		@research_cookie = Nil
		@auth_address = "https://teleservices.paris.fr/srtm/authentificationConnexion.action"
		@query_address = "https://teleservices.paris.fr/srtm/reservationCreneauListe.action"
		@result_pages_address = "https://teleservices.paris.fr/srtm/jsp/web/reservation/reservationCreneauListe.jsp"
	end
	
	def get_cookie()
		response = Unirest.get(@index_address)
		return response.headers[:set_cookie][0]
	end

	def connect(login, password)
		Unirest.post @auth_address, 
                        headers:{ "Accept" => "text/html", "Cookie" => @cookie }, 
                        parameters:{ :login => "xxx", :password => "xxx"}
	end

	def search_query(query_parameters)
		response = Unirest.post  @query_address, headers: {"Cookie" => @cookie}, parameters: query_parameters
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


# get or ask password
def get_password()
	# open file
	# if file not prompt for pwd
end

# post request to get reservation
def prepare_queries(place, date, hour)
	# ruby test call method on list? (test if can can each?)
	places = place.split(",")
	dates = date.split(",")
	hours = hour.split(",")
	
	queries = []
	places.each do |p|
		dates.each do |d|
			hours.each do |h|
				query = "" # see with the site
				queries.add(query)
			end
		end	
	end
	queries
end

# main to parse argument
# @todo look for argument parser ruby
def main()
	options = {}
	OptionParser.new do |opt|
		opt.on('-p p1,p2', 'Place', 'A place, favorites, or a list of places. 
					In the future, it could be a distrinct') { |o| options[:places] = o }
		opt.on('-d d1,d2', 'Date', 'A list of dates') { |o| options[:dates] = o }
		opt.on('-t t1,t2', 'Hour', 'A list of hours') { |o| options[:hours] = o }
	end.parse!
	
	#queries = prepare_queries(options[:places], options[:dates], options[:hour])

	tennis_paris = TennisSession.new()

	tennis_paris.connect("","")

	params = {:provenanceCriteres => true, :actionInterne => "recherche", :recherchePreferee => "on",
			:dateDispo => "08/07/2017", :libellePlageHoraire => "", :nomCourt => "", :champ => "", :tennisArrond => "",
			:arrondissement => "", :arrondissement2 => "", :arrondissement3 => "", :heureDispo => "", :plageHoraireDispo => "",
			:revetement => "", :court => "" }
	
	response = tennis_paris.search_query(params)
	puts response.body
end


main()
