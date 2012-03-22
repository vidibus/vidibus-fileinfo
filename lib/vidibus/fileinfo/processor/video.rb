module Vidibus
  module Fileinfo
    module Processor
      module Video
        FORMATS = %w[avi flv h261 h263 h264 ipod m4v mov mp4 mpeg mxf ogg]
        METADATA = %w[audio_codec audio_sample_rate content_type bitrate duration fps height size video_codec width]

        # FFmpeg command
        def cmd
          %Q(ffmpeg -i "#{@path}")
        end

        def output
          "stderr"
        end

        def validate
          %w[duration height width]
        end

        protected

        def audio_codec
          @raw_metadata[/Audio:\s+([a-z]+),/, 1]
        end

        def audio_sample_rate
          if match = @raw_metadata[/(\d+)\sHz/, 1]
            match.to_i
          end
        end

        def bitrate
          if match = @raw_metadata[/bitrate:\s(\d+)\skb\/s/, 1]
            match.to_i
          end
        end

        def content_type
          super('video')
        end

        def duration
          if match = @raw_metadata[/Duration:\s+([0-9\:\.]+),/, 1]
            units = match.split(":").map(&:to_f)
            units[0]*3600 + units[1]*60 + units[2]
          end
        end

        def fps
          if match = @raw_metadata[/([\d\.]+)\s+fps,/, 1]
            match.to_f
          end
        end

        def height
          dimension[1] if dimension
        end

        def width
          dimension[0] if dimension
        end

        def dimension
          if match = @raw_metadata[/^.*Video:.*?(\d+x\d+)/, 1]
            match.strip.split("x").map(&:to_i)
          end
        end

        def video_codec
          @raw_metadata[/Video:\s*([a-zA-Z0-9\s\(\)]*),/, 1]
        end
      end
    end
  end
end
