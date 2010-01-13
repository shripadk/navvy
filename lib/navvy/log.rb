module Navvy
  class Log
    class << self
      attr_writer :logger
      attr_accessor :quiet
    end

    def self.logger
      @logger || :rails
    end

    ##
    # Pass a log to the logger. It will check if self.logger is an array. If it
    # is, it'll loop through it and log to every logger. If it's not, it'll
    # just log once.
    #
    # @param [String] message the message you want to log

    def self.info(message)
      if logger.is_a? Array
        logger.each do |logger|
          write(logger, message)
        end
      else
        write(logger, message)
      end
    end
    
    ##
    # Actually write the log to the logger. It'll check self.logger and use
    # that to define a logger
    #
    # @param [Symbol] logger the logger you want to use
    # @param [String] message the message you want to log
    
    def self.write(logger, message)
      puts message unless quiet
      case logger
      when :justlogging
        Justlogging.log(message)
      else
        RAILS_DEFAULT_LOGGER.info(message)
      end
    end
  end
end