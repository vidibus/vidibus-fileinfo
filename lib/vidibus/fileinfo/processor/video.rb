module Vidibus
  module Fileinfo
    module Processor
      module Video
        FORMATS = %w[3g2 3gp asf avi dv f4p f4v flv ivf m21 mj2 mjpg mkv mov mp4 mpeg mpg mxf ogv rm ts webm wmv]
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
          @raw_metadata[/Audio:\s+([a-z0-9_]+),/, 1]
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
            f = units[0]*3600 + units[1]*60 + units[2]
            (f * 100).round.to_f / 100
          end
        end

        def fps
          match = @raw_metadata[/([\d\.]+)\s+fps,/, 1]
          match ||= @raw_metadata[/([\d\.]+)\s+tbr,/, 1]
          if match
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
          if match = @raw_metadata[/^.*Video:.*?,.*?(\d+x\d+)/, 1]
            match.strip.split("x").map(&:to_i)
          end
        end

        def video_codec
          if codec = @raw_metadata[/Video:\s*([a-zA-Z0-9\s\(\)]*)[\s\/,]+/, 1]
            codec.strip
          end
        end
      end
    end
  end
end
