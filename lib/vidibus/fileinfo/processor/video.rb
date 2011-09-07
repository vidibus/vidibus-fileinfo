module Vidibus
  module Fileinfo
    module Processor
      module Video
        FORMATS = %w[avi flv h261 h263 h264 ipod m4v mov mp4 mpeg mxf ogg]
        METADATA = %w[audio_codec audio_sample_rate bitrate duration fps height
          size video_codec width]

        def cmd
          "ffmpeg -i #{@path}"
        end

        def output
          :stderr
        end

        def valid?(metadata)
          !(metadata[:width].zero? || metadata[:height].zero? || metadata[:duration].zero?)
        end

        protected

        def audio_codec
          /Audio:\s+([a-z]+),/.match(@raw_metadata)[1].presence
        end

        def audio_sample_rate
          /(\d+)\sHz/.match(@raw_metadata)[1].presence.to_i
        end

        def bitrate
          /bitrate:\s(\d+)\skb\/s/.match(@raw_metadata)[1].presence.to_i
        end

        def duration
          str = /Duration:\s+([0-9\:\.]+),/.match(@raw_metadata)[1].presence
          units = str.split(":").map(&:to_f)
          (units[0] * 60 * 60 * 1000) + (units[1] * 60 * 1000) + (units[2] * 1000) / 1000
        end

        def fps
          /(\d+)\s+fps,/.match(@raw_metadata)[1].presence.to_f
        end

        def height
          dimension[1]
        end

        def width
          dimension[0]
        end

        def dimension
          str = /^.*Video:.*( \d+x\d+ ).*$/.match(@raw_metadata)[1].strip.presence
          str.split("x").map(&:to_i)
        end

        def video_codec
          /Video:\s+([a-z0-9]+),/.match(@raw_metadata).presence[1]
        end
      end
    end
  end
end
