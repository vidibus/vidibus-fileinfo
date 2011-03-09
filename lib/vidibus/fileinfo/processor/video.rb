module Vidibus
  module Fileinfo
    module Processor
      module Video
        FORMATS = %w[avi flv h261 h263 h264 ipod m4v mov mp4 mpeg mxf ogg]

        # Extracts image data through RVideo, which uses FFmpeg.
        def data
          raise PathError unless @path
          @data ||= begin
            rvideo = RVideo::Inspector.new(:file => path)
            raise DataError unless rvideo
            info = {
              :width => rvideo.width().to_i,
              :height => rvideo.height().to_i,
              :duration => rvideo.duration().to_f/1000,
              :size => File.size(path),
              :fps => rvideo.fps().to_f
            }
            raise DataError unless info[:width] > 0 and info[:height] > 0 and info[:duration] > 0
            [:bitrate, :audio_sample_rate, :audio_codec, :video_codec].each do |m|
              info[m] = rvideo.send(m)
            end
            info
          end
        end
      end
    end
  end
end
