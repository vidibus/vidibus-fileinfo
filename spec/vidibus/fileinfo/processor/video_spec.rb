require "spec_helper"

describe Vidibus::Fileinfo::Processor::Video do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp4_path)}
  let(:results) {load_fixture("video_results")}

  describe "FORMATS" do
    it "should include various video formats" do
      formats = %w[3g2 3gp asf avi dv f4p f4v flv ivf m21 mj2 mjpg mkv mov mp4 mpeg mpg mxf ogg ogv rm ts webm wmv]
      Vidibus::Fileinfo::Processor::Video::FORMATS.should eq(formats)
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[audio_codec audio_sample_rate content_type bitrate duration fps frame_rate height size video_codec width]
      Vidibus::Fileinfo::Processor::Video::METADATA.should eq(metadata)
    end
  end

  describe "#process_cmd" do
    it "should return raw metadata from an video" do
      subject.data.should_not be_empty
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it 'should raise a DataError if "height" validation fails' do
      stub(subject).height {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should raise a DataError if "width" validation fails' do
      stub(subject).width {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should raise a DataError if "duration" validation fails' do
      stub(subject).duration {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should include the content_type' do
      subject.data[:content_type].should eql('video/mp4')
    end

    context 'of a mpeg4 video' do
      before do
        stub(subject).process_cmd { results['mpeg4'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('aac')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(48000)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(602)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(1.92)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(25.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(405)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('mpeg4')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(720)
      end
    end

    context 'of a h264 video (example 1)' do
      before do
        stub(subject).process_cmd { results['h264_1'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('aac')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(48000)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(1136)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(44.73)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(25.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(406)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('h264 (High)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(720)
      end
    end

    context 'of a h264 video (example 2)' do
      before do
        stub(subject).process_cmd { results['h264_2'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('aac')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(44100)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(1098)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(1187.76)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(24.93)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(350)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('h264 (Main)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(620)
      end
    end

    context 'of a h264 video (example 3)' do
      before do
        stub(subject).process_cmd { results['h264_3'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('aac')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(44100)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(951)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(8172.36)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(25)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(350)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('h264 (Main)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(620)
      end
    end

    context 'of a h264 video (baseline example)' do
      before do
        stub(subject).process_cmd { results['h264_baseline'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('aac')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(44100)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(953)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(103.08)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(25.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(350)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('h264 (Constrained Baseline)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(620)
      end
    end

    context 'of a wmv video' do
      before do
        stub(subject).process_cmd { results['wmv'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('wmav2')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(44100)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(699)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(151.79)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(29.97)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(300)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('wmv3 (Main)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(400)
      end
    end

    context 'of an avi video' do
      before do
        stub(subject).process_cmd { results['avi'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('mp3')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(48000)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(2099)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(596.45)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(24.00)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(480)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('msmpeg4v2')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(854)
      end
    end

    context 'of an avi video without audio track' do
      before do
        stub(subject).process_cmd { results['avi_without_audio'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        @metadata[:audio_codec].should be_nil
      end

      it 'should not extract the audio sample rate' do
        @metadata[:audio_sample_rate].should be_nil
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(1071)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(6.25)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(40.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(240)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('IV41')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(256)
      end
    end

    context 'of an avi hypercam video without audio track' do
      before do
        stub(subject).process_cmd { results['avi_hypercam'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        @metadata[:audio_codec].should be_nil
      end

      it 'should not extract the audio sample rate' do
        @metadata[:audio_sample_rate].should be_nil
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(128)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(62.0)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(1.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(476)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('msvideo1')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(588)
      end
    end

    context 'of a mkv video without bitrate' do
      before do
        stub(subject).process_cmd { results['mkv_without_bitrate'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('aac')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(48000)
      end

      it 'should not extract the bitrate' do
        @metadata[:bitrate].should be_nil
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(44.58)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(23.98)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(256)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('h264 (High)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(592)
      end
    end

    context 'of a ts video' do
      before do
        stub(subject).process_cmd { results['ts'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('mp2')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(48000)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(5006)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(93.52)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(29.97)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(480)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('mpeg2video (Main)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(480)
      end
    end

    context 'of a webm video without bitrate' do
      before do
        stub(subject).process_cmd { results['webm_without_bitrate'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('vorbis')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(44100)
      end

      it 'should not extract the bitrate' do
        @metadata[:bitrate].should be_nil
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(5.56)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(30)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(314)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('vp8')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(558)
      end
    end

    context 'of an ogg video' do
      before do
        stub(subject).process_cmd { results['ogg'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('vorbis')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(44100)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(504)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(64.93)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(29.97)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(240)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('theora')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(320)
      end
    end

    context 'of a mxf video without audio' do
      before do
        stub(subject).process_cmd { results['mxf_without_audio'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        @metadata[:audio_codec].should be_nil
      end

      it 'should not extract the audio sample rate' do
        @metadata[:audio_sample_rate].should be_nil
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(2101)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(10.72)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(25.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(576)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('mpeg2video (Main)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(720)
      end
    end

    context 'of a mjpg video' do
      before do
        stub(subject).process_cmd { results['mjpg'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('pcm_s16be')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(16000)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(26751)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(20.50)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(30.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(720)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('mjpeg')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(1280)
      end
    end

    context 'of an ivf video without audio track' do
      before do
        stub(subject).process_cmd { results['ivf_without_audio'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        @metadata[:audio_codec].should be_nil
      end

      it 'should not extract the audio sample rate' do
        @metadata[:audio_sample_rate].should be_nil
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(13983)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(10.0)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(50.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(1080)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('vp8')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(1920)
      end
    end

    context 'of a mov video' do
      before do
        stub(subject).process_cmd { results['mov'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        @metadata[:audio_codec].should eq('aac')
      end

      it 'should extract the audio sample rate' do
        @metadata[:audio_sample_rate].should eq(48000)
      end

      it 'should extract the bitrate' do
        @metadata[:bitrate].should eq(3342)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(596.48)
      end

      it 'should extract frames per second' do
        @metadata[:fps].should eq(24.0)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(480)
      end

      it 'should extract the video codec' do
        @metadata[:video_codec].should eq('h264 (Main)')
      end

      it 'should extract the width' do
        @metadata[:width].should eq(854)
      end
    end

    it "should raise DataError if metadata is invalid" do
      stub(subject).process_cmd {results["invalid_data"]}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end
  end

  describe '#content_type' do
    let(:mime_types) do
      {
        '3g2' => 'video/3gpp2',
        '3gp' => 'video/3gpp',
        'asf' => 'video/x-ms-asf',
        'avi' => 'video/x-msvideo',
        'dv' => 'video/x-dv',
        'f4p' => 'video/mp4',
        'f4v' => 'video/mp4',
        'flv' => 'video/x-flv',
        'ivf' => 'video/x-ivf',
        'mj2' => 'video/MJ2',
        'mjpg' => 'video/x-motion-jpeg',
        'mkv' => 'video/x-matroska',
        'mov' => 'video/quicktime',
        'mp4' => 'video/mp4',
        'mpeg' => 'video/mpeg',
        'mpg' => 'video/mpeg',
        'mxf' => 'application/mxf',
        'ogg' => 'video/ogg',
        'ogv' => 'video/ogg',
        'rm' => 'application/vnd.rn-realmedia',
        'ts' => 'video/MP2T',
        'webm' => 'video/webm',
        'wmv' => 'video/x-ms-wmv'
      }
    end

    Vidibus::Fileinfo::Processor::Video::FORMATS.each do |format|
      it "should be valid for '#{format}'" do
        stub(subject).path { "something.#{format}" }
        stub(subject).format { format }
        subject.send(:content_type).should eq(mime_types[format])
      end
    end
  end
end
