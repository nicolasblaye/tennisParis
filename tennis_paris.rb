require 'unirest'
require 'optparse'
require_relative 'tennis_session'
require_relative 'tennis_parser'

def parse_arg
  options = {}
  options[:dates] = []
  options[:hours] = []
  OptionParser.new do |opt|
    opt.on('-d dd', 'Date', 'A day in dd format') do |o|
      options[:dates].push(o)
    end
    opt.on('-h hh', 'Hour', 'An hour in hh format, between 18 and 21') do |o|
      options[:hours].push(o)
    end
  end.parse!
  options
end

def main(date, hour)
  logger = Logger.new(STDOUT)
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

  while TennisParser.next_link?(current_html)
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

  tennis_paris.reservation_page(slots[0].reservation_key)
              .body
              .encode('UTF-8', 'ISO-8859-1')

  captcha = tennis_paris.captcha_getter

  # read it?
  print(tennis_paris.validate_reservation('test').body.encode('UTF-8', 'ISO-8859-1'))
end


options = parse_arg
if options != []
  date = options[:dates][0]
  hour = options[:hours][0]
end
logger = Logger.new(STDOUT)
if hour.nil? || date.nil?
  logger.error('Need at least an hour and a date')
else
  main(date, hour)
end