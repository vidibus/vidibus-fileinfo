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

      # Return the mime type of the current instance.
      # If a media_type is given, only a matching mime
      # type will be returned.
      def mime_type(media_type = nil)
        types = MIME::Types.type_for(path)
        return if types.empty?
        if media_type
          media_type = media_type.to_s
          media_types = types.select { |m| m.media_type == media_type }
          if media_types.length > 1
            sub_types = media_types.select { |m| m.sub_type == format }
            media_types = sub_types if sub_types.any?
          end
          types = media_types if media_types.any?
        end
        types.first.content_type if types.any?
      end
      alias :content_type :mime_type

      def data
        raise PathError unless path
        @data ||= parse_metadata
      end

      def video?
        false
      end

      def audio?
        false
      end

      def image?
        false
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
        @raw_metadata = process_cmd.force_encoding('ISO8859-1')
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
