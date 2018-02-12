module Goatmail
  class Railtie < Rails::Railtie
    initializer "goatmail.add_delivery_method" do
      ActiveSupport.on_load :action_mailer do
        ActionMailer::Base.add_delivery_method :goatmail, Goatmail::DeliveryMethod, location: Goatmail.location
      end
    end
  end if defined? Rails::Railtie
end
