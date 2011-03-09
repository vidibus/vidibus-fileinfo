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
        @format ||= Fileinfo.format(@path)
      end

      def mime_type
        @mime_type ||= Mime::Type.lookup_by_extension(format)
      end

      protected

      def check_file
        raise FileAccessError unless File.exist?(@path)
        raise NoFileError unless File.file?(@path)
      end

      def load_processor
        @processor = Fileinfo.processor(format)
        extend @processor
      end
    end
  end
end
