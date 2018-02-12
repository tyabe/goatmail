require 'letter_opener'

module Goatmail
  class DeliveryMethod < LetterOpener::DeliveryMethod

    def initialize(options = {})
      options[:location] ||= Goatmail.location
      super
      raise InvalidOption, "A location option is required when using the Goatmail delivery method" if Goatmail.location.nil?
    end

    def deliver!(mail)
      validate_mail!(mail)
      location = File.join(settings[:location], "#{Time.now.to_f.to_s.tr('.', '_')}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = LetterOpener::Message.rendered_messages(mail, location: location, message_template: settings[:message_template])
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
