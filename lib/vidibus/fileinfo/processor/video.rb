module Vidibus
  module Fileinfo
    module Processor
      module Video
        FORMATS = %w(avi flv h261 h263 h264 ipod m4v mov mp4 mpeg mxf ogg)

        # Extracts video data using FFmpeg.
        def data
          raise PathError unless @path
          @data ||= parse_metadata
        end

        private

        def parse_metadata
          @raw_metadata = run_ffmpeg_cmd

          metadata = {}
          attr = %w(width height duration size fps audio_codec
                    video_codec audio_sample_rate bitrate)

          attr.each do |attribute|
            metadata[attribute.to_sym] = method(attribute).call
          end

          validate(metadata)
          metadata
        end

        def validate(metadata)
          raise DataError unless valid?(metadata)
        end

        def valid?(metadata)
          !(metadata[:width].zero? || metadata[:height].zero? || metadata[:duration].zero?)
        end

        def run_ffmpeg_cmd
          cmd = "ffmpeg -i #{@path}"
          pid, stdin, stdout, stderr = POSIX::Spawn::popen4(cmd)
          output = stderr.read
          Process::waitpid(pid)
          output
        end

        # The width of the video in pixels.
        def width
          dimensions[0]
        end

        # The height of the video in pixels.
        def height
          dimensions[1]
        end

        # The video dimensions e.g. [600, 400]
        def dimensions
          str = /^.*Video:.*( \d+x\d+ ).*$/.match(@raw_metadata)[1].strip
          /(\d+)x(\d+)/.match(str)[1..2].map(&:to_i)
        end

        # The duration of the video in seconds.
        def duration
          str = /Duration:\s+([0-9\:\.]+),/.match(@raw_metadata)[1]
          units = str.split(":").map(&:to_f)
          (units[0] * 60 * 60 * 1000) + (units[1] * 60 * 1000) + (units[2] * 1000) / 1000
        end

        # The video file size in bytes.
        def size
          File.size(@path)
        end

        # The frame rate per second.
        def fps
          /(\d+)\s+fps,/.match(@raw_metadata)[1].to_f
        end

        def bitrate
          /bitrate: (\d+) kb\/s/.match(@raw_metadata)[1].to_i
        end

        def audio_codec
          /Audio:\s+([a-z]+),/.match(@raw_metadata)[1]
        end

        def video_codec
          /Video:\s+([a-z0-9]+),/.match(@raw_metadata)[1]
        end

        def audio_sample_rate
          /(\d+) Hz/.match(@raw_metadata)[1].to_i
        end
      end
    end
  end
end
