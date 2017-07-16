require 'nokogiri'
require_relative 'tennis_slot'

class TennisParser

  @@host = 'https://teleservices.paris.fr'

  # get the research pages links
  def self.get_links(html)
    parsed_html = Nokogiri::HTML(html)
    result = parsed_html.css('span.pagelinks/a/@href')
    result[0..-3].map { |x| @@host + x }
  end

  def self.parse_page(html)
    trs = Nokogiri::HTML(html).xpath('//tbody/tr')
    trs.map { |tr| parse_column(tr.to_s) }
  end

  def self.parse_column(tr)
    columns = Nokogiri.XML(tr).xpath('//td')
    TennisSlot.new(
        columns[0].text,
        columns[2].text,
        columns[3].text,
        columns[4].text.scan( /(\d*)/)[-2].first.to_i,
        get_reservation_keys(columns.last.children.first.attribute('href').to_s)
    )
  end

  def self.get_reservation_keys(string)
    array = string.split('\'')
    { 'cle' => array[1], 'libelleReservation' => array[5], 'rechercheElargie' => ''}
  end

  def self.get_next_link(html)
    parsed_html = Nokogiri::HTML(html)
    result = parsed_html.css('span.pagelinks/a/@href')
    @@host + result[-2]
  end

  def self.has_next_link(html)
    parsed_html = Nokogiri::HTML(html)
    result = parsed_html.css('span.pagelinks/a')
    result.select { |a| a.text == 'Suivant' }.size == 1
  end
end
