require 'nokogiri'
require_relative 'tennis_slot'

class TennisParser

  # get the research pages links
  def self.get_links(html)
    parsed_html = Nokogiri::HTML(html)
    result = parsed_html.css('span.pagelinks/a/@href')
    result[0..-3].map { |x| 'https://teleservices.paris.fr' + x }
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
end
