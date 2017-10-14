require 'net/smtp'

class MailSender
  def self.send_slots(slots, mail)
    message = <<MESSAGE_END
      From: Tennis Paris <tennisParis@localhost.localdomain>
      To: A Test User <#{mail}>
      Subject: SMTP e-mail test

      This is a test e-mail message.
MESSAGE_END

    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message(message, 'tennisParis@localhost.com', mail)
    end
  end
end

MailSender.send_slots(nil, 'nicolas_blaye@hotmail.fr')
