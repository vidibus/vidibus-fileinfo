module Vidibus
  module Fileinfo
    class Base
      attr_accessor :path, :processor

      def initialize(path)
        @path = path
        check_file
        load_processor
      end

      def format
        @format ||= Fileinfo.format(path)
      end

      def mime_type
        @mime_type ||= begin
          if mime = MIME::Types.type_for(@path)
            mime.first.simplified
          end
        end
      end

      def data
        raise PathError unless path
        @data ||= parse_metadata
      end

      protected

      def check_file
        raise FileAccessError unless File.exist?(path)
        raise NoFileError unless File.file?(path)
      end

      def load_processor
        @processor = Fileinfo.processor(format)
        extend @processor
      end

      def parse_metadata
        @raw_metadata = process_cmd
        metadata = {}
        @processor::METADATA.each do |attribute|
          if data = send(attribute)
            metadata[attribute.to_sym] = data
          end
        end
        raise DataError.new("Invalid metadata:\n#{@raw_metadata}") unless valid?(metadata)
        metadata
      end

      def process_cmd
        pid, stdin, stdout, stderr = POSIX::Spawn::popen4(cmd)
        raw_metadata = eval(output).read
        Process::waitpid(pid)
        raw_metadata
      end

      # Important attributes must be present and valid
      def valid?(metadata)
        validate.each do |attr|
          return false if metadata[attr.to_sym].nil? || metadata[attr.to_sym].zero?
        end
      end

      # The video/image file size in bytes.
      def size
        File.size(path)
      end
    end
  end
end
