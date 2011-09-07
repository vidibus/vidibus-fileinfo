module Vidibus
  module Fileinfo
    module Processor
      module Image
        FORMATS = %w[jpg jpeg png gif]
        METADATA = %w[bit content_type height orientation quality size width]

        def cmd
          "identify -verbose #{@path}"
        end

        def output
          :stdout
        end

        def valid?(metadata)
          !(metadata[:width].zero? || metadata[:height].zero?)
        end

        protected

        def bit
          /^\s*Depth:\s(\w+)-bit/.match(@raw_metadata)[1].presence.to_i
        end

        def content_type
          /^\s*Format:\s(\w+)/.match(@raw_metadata)[1].presence.downcase
        end

        def height
          dimension[1]
        end

        def width
          dimension[0]
        end

        def dimension
          str = /^\s*Geometry: (\w+)/.match(@raw_metadata)[1].presence
          str.split("x").map(&:to_i)
        end

        def orientation
          /^\s*exif:Orientation:\s(\d+)/.match(@raw_metadata)[1].presence.to_i
        end

        def quality
          /^\s*Quality: (\d+)/.match(@raw_metadata)[1].presence.to_i
        end
      end
    end
  end
end
