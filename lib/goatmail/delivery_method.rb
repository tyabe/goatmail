require 'letter_opener'

module Goatmail
  class DeliveryMethod < LetterOpener::DeliveryMethod

    def initialize(options = {})
      raise InvalidOption, "A location option is required when using the Goatmail delivery method" if Goatmail.location.nil?
      self.settings = options
    end

    def deliver!(mail)
      location = File.join(Goatmail.location, "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = LetterOpener::Message.rendered_messages(location, mail)
      meta_data = {
        subject: mail.subject.to_s,
        to:      mail.to.join(", "),
        from:    mail.from.join(', ')
      }
      File.open(File.join(location, 'meta'), 'wb') {|f| Marshal.dump(meta_data, f)}
      messages
    end
  end
end
