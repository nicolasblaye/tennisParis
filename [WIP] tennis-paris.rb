#require("nokogiri")
require("unirest")
require("optparse")

path = "~/.pwd/tennis_paris"

## A class to store the session token and some url
class TennisSession
	def initialize()
		@index_address = "https://teleservices.paris.fr/srtm/jsp/web/index.jsp"
		@token = get_token
		@auth_address = "https://teleservices.paris.fr/srtm/authentificationConnexion.action?jsessionid=" + @token
		@query_address = "https://teleservices.paris.fr/srtm/reservationCreneauListe.action.jsessionid=" + @token
		@result_pages_address = Nil
	end
	
	def get_token()
		response = Unirest.get(@index_address)
		return response.headers[:set_cookie][0].split("; ")[0]
	end

	def connect(login, password)
		response = Unirest.post @auth_address, 
                        headers:{ "Accept" => "text/html" }, 
                        parameters:{ :login => login, :password => password }
	end

	def search_query(query_parameters)
		response = Unirest.post  @query_address, parameters: query_parameters
		pages = 1
		(1..pages).each do |n|
			
	end
end

## do everything with a class
def set_cookie()
	
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

	response = Unirest.get "https://teleservices.paris.fr/srtm/jsp/web/index.jsp"

	puts response.code
	puts response.headers
	puts response.headers[:set_cookie][0].split("; ")[0]
	
	return true

	response = Unirest.post "https://teleservices.paris.fr/srtm/authentificationConnexion.action&jsessionid=A8FBB0B9CBDBDFBD7D50CA2F1964D6BF", 
                        headers:{ "Accept" => "text/html" }, 
                        parameters:{ :login => "06039313", :password => "8288" }

	puts response.code # Status code
	puts response.body
	#r = prepare_queries()
	#results = []
	#r.each do
	#	request = r.post(query, auth)
	#	results.add(request.html)
	#end
end

# parse result page of the query
def parse_result(html)
	# iterate over all pages
	#return list(result)
end

def send_mail(to, results)
	if results
		# aggregate results to send a mail
		mail = results.each do
	end
end
	
end


main()


