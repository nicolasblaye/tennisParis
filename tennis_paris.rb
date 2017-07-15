#require("nokogiri")
require 'unirest'
require 'optparse'
require_relative 'tennis_session'
require_relative 'tennis_parser'

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
def main()
  # options = {}
  # OptionParser.new do |opt|
  #   opt.on('-p p1,p2', 'Place', 'A place, favorites, or a list of places.
  # 			In the future, it could be a distrinct') {|o| options[:places] = o}
  #   opt.on('-d d1,d2', 'Date', 'A list of dates') {|o| options[:dates] = o}
  #   opt.on('-t t1,t2', 'Hour', 'A list of hours') {|o| options[:hours] = o}
  # end.parse!
  #
  # #queries = prepare_queries(options[:places], options[:dates], options[:hour])

  tennis_paris = TennisSession.new

  tennis_paris.connect

  params = {
      provenanceCriteres: true, actionInterne: 'recherche',
      recherchePreferee: 'on', dateDispo: '', libellePlageHoraire: '',
      nomCourt: '', champ: '', tennisArrond: '', arrondissement: '',
      arrondissement2: '', arrondissement3: '', heureDispo: '',
      plageHoraireDispo: '18@21', revetement: '', court: ''
  }

  response = tennis_paris.search_query(params)
  page1_html = response.body.encode('UTF-8', 'ISO-8859-1')

  links = TennisParser.get_links(page1_html)
  slots = TennisParser.parse_page(page1_html)

  puts links

  links.each do |link|
    html = tennis_paris.get_search_page(link).body.encode('UTF-8', 'ISO-8859-1')
    slots.push(*TennisParser.parse_page(html))
  end

  puts slots.size
end


main
