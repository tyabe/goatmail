require 'sinatra/base'
require 'tilt/erb'
require 'erb'
require 'goatmail/message'
module Goatmail
  class App < Sinatra::Base

    if defined?(Padrino) && Padrino.version < '0.13.0'
      def self.setup_application!; end
      def self.dependencies; []; end
      def self.reload!; end
      set :app_name, :letter_opener
      if Padrino.version < '0.12.0'
        set :erb, engine_class: Padrino::Erubis::SafeBufferTemplate
      end
    end

    configure do
      set :root,          File.expand_path(File.dirname(__FILE__))
      set :public_folder, Proc.new { "#{root}/assets" }
      set :views,         Proc.new { "#{root}/views" }

      enable :method_override
    end

    helpers do
      def root_path
        "#{env['SCRIPT_NAME']}/"
      end

      def h(text)
        Rack::Utils.escape_html(text)
      end

      def title
        [ settings.environment, Goatmail.name ].join("::")
      end
    end

    get '/' do
      @messages = Goatmail::Message.load_all
      erb :index
    end

    get '/:id.?:format?' do
      @message = Goatmail::Message.find(params[:id])
      halt 404 unless @message
      begin
        @message.render(params[:format]).to_s.
          gsub(/"plain\.html"/, %Q("#{root_path + @message.id}")).
          gsub(/"rich\.html"/,  %Q("#{root_path + @message.id}.html")).
          gsub(/"attachments\//, %Q("#{root_path + @message.id}/attachments/))
      rescue ArgumentError
        halt 404
      end
    end

    get '/:id/attachments/:file' do
      @message = Goatmail::Message.find(params[:id])
      halt 404 unless @message
      halt 404 unless attachment = @message.attachments[params[:file]]
      send_file attachment, disposition: 'attachment', type: 'application/octet-stream'
    end

    delete '/' do
      Goatmail::Message.bulk_delete(params[:message_ids].split(',').map(&:strip)) if params[:message_ids]
      redirect root_path
    end

    error 404 do
      'Not Found'
    end

  end
end
