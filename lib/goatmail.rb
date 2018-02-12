require 'goatmail/delivery_method'
require 'goatmail/app'

module Goatmail
  class << self
    def location
      @location ||= LetterOpener.configuration.location
      @location ||= Rails.root.join('tmp/goatmail')  if defined? Rails
      @location ||= Padrino.root('tmp/goatmail')     if defined? Padrino
      @location
    end

    def location=(path)
      @location = path
    end
  end
end

require "goatmail/railtie" if defined? Rails::Railtie
