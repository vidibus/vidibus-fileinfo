module Vidibus
  module Fileinfo
    module Processor
      module Image
        FORMATS = %w[jpg jpeg png gif]

        # Extracts image data through ImageMagick.
        def data
          raise PathError unless @path
          @data ||= begin
            result = perform or raise DataError
            values = result.to_s.split(" ")
            raise DataError unless values.size > 5
            dimensions = values[2].split('x').map {|d| d.to_i}
            raise DataError unless dimensions.any?
            {
              :content_type => values[1].downcase,
              :width => dimensions[0],
              :height => dimensions[1],
              :bit => values[4].to_i,
              :size => File.size(@path)
            }
          end
        end

        protected

        def perform
          result = `#{command}`
          raise DataError unless $? == 0
          result
        end

        def command
          "identify #{@path}"
        end
      end
    end
  end
end
