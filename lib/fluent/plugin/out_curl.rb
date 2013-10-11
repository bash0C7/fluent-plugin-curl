
module Fluent
  class Fluent::CurlOutput < Fluent::Output
    Fluent::Plugin.register_output('curl', self)

    def initialize
      super
    end

    config_param :curl_command, :string, :default => 'curl'
    config_param :url_template, :string
    config_param :options_template, :string
    config_param :body_template, :string, :default => ''

    def configure(conf)
      super

      @url_erb = ERB.new(@url_template)
      @options_erb = ERB.new(@options_template)
      @body_erb = ERB.new(@body_template)
    end

    def start
      super
    end

    def shutdown
      super
    end

    def emit(tag, es, chain)
      es.each {|time,record|
        begin
          #          Kernel.exec("#{curl_command} #{@url_erb.result(binding)} #{@options_erb.result(binding)}")
          IO.popen("#{curl_command} #{@url_erb.result(binding)} #{@options_erb.result(binding)}", 'w') do |io|
            io.puts @body_erb.result(binding)
          end
        rescue IOError, EOFError, SystemCallError
          $log.warn "raises exception: #{$!.class}, '#{$!.message}'"
        end
      }
      chain.next
    end
  end
end
