module Vidibus
  module Fileinfo
    module Processor
      module Audio
        FORMATS = %w[
          mp3
        ]
        METADATA = %w[
          codec sample_rate content_type bit_rate duration
        ]

        # FFmpeg command
        def cmd
          %Q(ffmpeg -i "#{@path}")
        end

        def output
          'stderr'
        end

        def validate
          %w[duration]
        end

        def audio?
          true
        end

        protected

        def codec
          @raw_metadata[/Audio:\s+([a-z0-9_]+).*,.*\d+\sHz/, 1]
        end

        def sample_rate
          if match = @raw_metadata[/(\d+)\sHz/, 1]
            match.to_i
          end
        end

        # Return the bit rate defined as "bitrate". Calculate it from
        # file size and duration otherwise.
        # 1 kilobit == 1000 bit
        def bit_rate
          if match = @raw_metadata[/bitrate:\s(\d+)\skb\/s/, 1]
            match.to_i * 1000
          elsif duration && duration > 0
            (size.to_f/1.024/duration*8).round
          end
        end

        def content_type
          super('audio')
        end

        def duration
          if match = @raw_metadata[/Duration:\s+([0-9\:\.]+),/, 1]
            units = match.split(":").map(&:to_f)
            f = units[0]*3600 + units[1]*60 + units[2]
            (f * 100).round.to_f / 100
          end
        end
      end
    end
  end
end
