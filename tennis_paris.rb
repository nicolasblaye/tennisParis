require 'unirest'
require 'optparse'
require_relative 'tennis_session'
require_relative 'tennis_parser'

def parse_arg
  options = {}
  OptionParser.new do |opt|
    opt.on('-d d', 'Date', 'A day in dd format') do |o|
      options[:dates] = o
    end
    opt.on('-t t', 'Hour', 'An hour in hh format, between 18 and 21') do |o|
      options[:hours] = o
    end
  end.parse!
end


logger = Logger.new(STDOUT)
options = parse_arg
date = options[:date]
hour = options[:hour]

if hour.nil? || date.nil?
  logger.error('Need at least an hour and a date')
  return
end

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
current_html = response.body.encode('UTF-8', 'ISO-8859-1')

slots = TennisParser.parse_page(current_html)

while TennisParser.has_next_link(current_html)
  next_link = TennisParser.get_next_link(current_html)
  current_html = tennis_paris.get_search_page(next_link)
                             .body
                             .encode('UTF-8', 'ISO-8859-1')
  slots.push(*TennisParser.parse_page(current_html))
end

logger.info("#{slots.size} tennis courts available")
slots = slots.select { |x| date.include?(x.date.split('/').first) }
             .select { |x| hour.include?(x.hour.split('h').first) }

logger.info("#{slots.size} tennis courts that you might want")
