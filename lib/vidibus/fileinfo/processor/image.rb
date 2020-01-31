module Vidibus
  module Fileinfo
    module Processor
      module Image
        FORMATS = %w[jpg jpeg png gif]
        METADATA = %w[bit content_type height orientation quality size width]

        # ImageMagick command
        def cmd
          %Q(identify -verbose "#{@path}")
        end

        def output
          "stdout"
        end

        def validate
          %w[height width]
        end

        def image?
          true
        end

        protected

        def bit
          if match = @raw_metadata[/^\s*Depth:\s(\w+)-bit/, 1]
            match.to_i
          end
        end

        def content_type
          super('image')
        end

        def height
          dimension[1] if dimension
        end

        def width
          dimension[0] if dimension
        end

        def dimension
          if match = @raw_metadata[/^\s*Geometry:\s(\w+)/, 1]
            match.split("x").map(&:to_i)
          end
        end

        def orientation
          if match = @raw_metadata[/^\s*Orientation:\s(.+)/, 1]
            match
          end
        end

        def quality
          if match = @raw_metadata[/^\s*Quality:\s(\d+)/, 1]
            match.to_i
          end
        end
      end
    end
  end
end
