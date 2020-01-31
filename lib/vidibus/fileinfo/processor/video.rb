module Vidibus
  module Fileinfo
    module Processor
      module Video
        FORMATS = %w[
          3g2 3gp asf avi dv f4p f4v flv ivf m21 mj2 mjpg mkv mov mp4 mpeg mpg
          mts mxf ogg ogv rm ts webm wmv
        ]
        METADATA = %w[
          aspect_ratio audio_codec audio_sample_rate content_type bit_rate
          duration frame_rate height size video_codec width
        ]

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

        def video?
          true
        end

        protected

        def audio_codec
          @raw_metadata[/Audio:\s+([a-z0-9_]+).*,.*\d+\sHz/, 1]
        end

        def audio_sample_rate
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
          super('video')
        end

        # Return display aspect ratio defined as DAR.
        # If no value is defined, calculate it from dimensions.
        # If no dimensions are given, nothing is returned.
        def aspect_ratio
          if matches = @raw_metadata.match(/DAR\s+([0-9]+):([0-9]+)/)
            w = $1.to_f
            h = $2.to_f
          elsif dimension
            w = dimension[0].to_f
            h = dimension[1].to_f
          end
          if w && h && w > 0 && h > 0
            w/h
          end
        end

        # Return pixel aspect ratio defined as PAR or SAR.
        # If no value is defined, 1.0 will be returned.
        def pixel_aspect_ratio
          ar = 1.0
          if matches = @raw_metadata.match(/(?:P|S)AR\s+([0-9]+):([0-9]+)/)
            w = $1.to_f
            h = $2.to_f
            if w > 0 && h > 0
              ar = w/h
            end
          end
          ar
        end

        def duration
          if match = @raw_metadata[/Duration:\s+([0-9\:\.]+),/, 1]
            units = match.split(":").map(&:to_f)
            f = units[0]*3600 + units[1]*60 + units[2]
            (f * 100).round.to_f / 100
          end
        end

        def frame_rate
          match = @raw_metadata[/([\d\.]+)\s+fps,/, 1]
          match ||= @raw_metadata[/([\d\.]+)\s+tbr,/, 1]
          if match
            match.to_f
          end
        end

        def height
          dimension[1] if dimension
        end

        # Return height from dimensions and apply
        # pixel aspect ratio.
        def width
          if dimension
            w = dimension[0]
            if pixel_aspect_ratio != 1
              return (w * pixel_aspect_ratio).round
            end
            w
          end
        end

        def dimension
          if match = @raw_metadata[/^.*Video:.*?,.*?(\d+x\d+)/, 1]
            match.strip.split('x').map(&:to_i)
          end
        end

        def video_codec
          if codec = @raw_metadata[/Video:\s*([a-zA-Z0-9]*(?:\s*\([a-zA-Z ]+\))?)[\s\/,]+/, 1]
            codec.strip
          end
        end
      end
    end
  end
end
