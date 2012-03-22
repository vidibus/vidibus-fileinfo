require "spec_helper"

describe Vidibus::Fileinfo::Processor::Video do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp4_path)}
  let(:results) {load_fixture("video_results")}

  describe "FORMATS" do
    it "should include various video formats" do
      formats = %w[3g2 3gp asf avi dv f4p f4v flv ivf m21 mj2 mjpg mkv mov mp4 mpeg mpg mxf ogv rm ts webm wmv]
      Vidibus::Fileinfo::Processor::Video::FORMATS.should eq(formats)
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[audio_codec audio_sample_rate content_type bitrate duration fps height size video_codec width]
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
