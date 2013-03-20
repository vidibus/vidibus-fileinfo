require "vidibus/fileinfo/base"
require "vidibus/fileinfo/processor/image"
require "vidibus/fileinfo/processor/video"
require "vidibus/fileinfo/processor/audio"

module Vidibus
  module Fileinfo

    class Error < StandardError; end
    class FileAccessError < Error; end
    class NoFileError < Error; end
    class NoFormatError < Error; end
    class UnitError < Error; end
    class UnsupportedFormatError < Error; end
    class ProcessorError < Error; end
    class PathError < ProcessorError; end
    class DataError < ProcessorError; end

    class << self

      # Returns a list of available processors.
      def processors
        @processors ||= [Processor::Image, Processor::Video, Processor::Audio]
      end

      # Returns a list of processable formats.
      def formats
        @formats ||= mapping.keys.sort
      end

      # Returns a processor class for given format.
      # If no processor matches, an UnsupportedFormatError will be raised.
      def processor(format)
        mapping[format.to_s] or raise UnsupportedFormatError
      end

      # Returns the format of a given file path.
      # If no format can be detected, a NoFormatError will be raised.
      def format(path)
        if path =~ /(?:\.)([a-z0-9]+)$/i
          $1.downcase
        else
          raise NoFormatError
        end
      end

      # Converts given size string with unit to bytes number.
      #
      # Example:
      #   Vidibus::Fileinfo.bytes("0.23 MB") #=> 241172
      #
      def bytes(value)
        if value.is_a?(String)
          value =~ /([\d\.]+)\s*(\w*)/i
          size = $1.to_f
          unit = $2.strip.upcase if $2
          power = case unit
            when "B", ""   then 0
            when "K", "KB" then 1
            when "M", "MB" then 2
            when "G", "GB" then 3
            when "T", "TB" then 4
            else raise UnitError
          end
          factor = 1024**power
          (size*factor).round
        elsif value.is_a?(Float)
          value.round
        elsif value.is_a?(Integer)
          value
        else
          raise ArgumentError
        end
      end

      protected

      def mapping
        @mapping ||= begin
          map = {}
          processors.each do |processor|
            for format in processor::FORMATS
              map[format] = processor
            end
          end
          map
        end
      end
    end
  end
end

# Shorthand for Vidibus::Fileinfo::Base.new
# Returns data hash.
def Fileinfo(path)
  Vidibus::Fileinfo::Base.new(path).data
end
