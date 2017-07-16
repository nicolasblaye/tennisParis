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
    columns = Nokogiri.XML(tr).text
            .split(' ')
            .delete_if { |x| x == '' }
    TennisSlot.new(
        columns[0] + ' ' + columns[1],
        columns[3],
        columns[4],
        columns[6]
    )
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
