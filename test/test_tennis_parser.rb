require 'minitest/autorun'

require_relative '../tennis_parser'
require_relative '../tennis_slot'

class TestTennisParser < Minitest::Test
  def setup
    puts Dir.pwd
    @html = File.open('./test/test.html', 'r') do |file|
      file.read.encode('UTF-8', 'ISO-8859-1')
    end
  end

  def test_parse_page
    slots = TennisParser.parse_page(@html)
    slot = TennisSlot.new('Suzanne Lenglen',
                          '17/07/2017', '18h00',
                          3, {
                              'libelleReservation' => 'Court%20n%C3%82%C2%B03%20du%20tennis%20Suzanne%20Lenglen%20le%20lundi%2017%20juillet%202017%20%C3%83%C2%A0%2018h00',
                              'rechercheElargie' => '',
                              'cle' => '1772@17/07/2017%2018h00@11@130@188@39' }
                          )
    first = slots.first
    assert_equal( first.date, slot.date)
    assert_equal( first.hour, slot.hour)
    assert_equal( first.court, slot.court)
    assert_equal( first.tennis_name, slot.tennis_name)
    assert_equal( first.reservation_keys, slot.reservation_keys)

    assert_equal(slots.size, 20)
  end

  def test_has_next_link
    assert(TennisParser.next_link?(html))
  end

  def test_get_next_link
    assert_equal(TennisParser.get_next_link(@html),
                 'https://teleservices.paris.fr/srtm/jsp/web/reservation/reservationCreneauListe.jsp?nomCourt=&dateDispo=&court=&d-41734-p=2&arrondissement2=&arrondissement3=&libellePlageHoraire=&tennisArrond=&provenanceCriteres=true&champ=&actionInterne=recherche&arrondissement=&revetement=&plageHoraireDispo=18%4021&recherchePreferee=on&heureDispo=')
  end
end