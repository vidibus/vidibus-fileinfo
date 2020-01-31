require "spec_helper"

describe Vidibus::Fileinfo::Processor::Video do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp4_path)}
  let(:results) {load_fixture("video_results")}

  describe "FORMATS" do
    it "should include various video formats" do
      formats = %w[3g2 3gp asf avi dv f4p f4v flv ivf m21 mj2 mjpg mkv mov mp4 mpeg mpg mts mxf ogg ogv rm ts webm wmv]
      expect(Vidibus::Fileinfo::Processor::Video::FORMATS).to eq(formats)
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[aspect_ratio audio_codec audio_sample_rate content_type bit_rate duration frame_rate height size video_codec width]
      expect(Vidibus::Fileinfo::Processor::Video::METADATA).to eq(metadata)
    end
  end

  describe "#process_cmd" do
    it "should return raw metadata from an video" do
      expect(subject.data).not_to be_empty
    end
  end

  describe "#audio?" do
    it "returns false" do
      expect(subject.audio?).to be_falsey
    end
  end

  describe "#video?" do
    it "returns true" do
      expect(subject.video?).to be_truthy
    end
  end

  describe "#image?" do
    it "returns false" do
      expect(subject.image?).to be_falsey
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it 'should raise a DataError if "height" validation fails' do
      allow(subject).to receive(:height) {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should raise a DataError if "width" validation fails' do
      allow(subject).to receive(:width) {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should raise a DataError if "duration" validation fails' do
      allow(subject).to receive(:duration) {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should include the content_type' do
      expect(subject.data[:content_type]).to eql('video/mp4')
    end

    context 'of a mpeg4 video' do
      before do
        allow(subject).to receive(:process_cmd) { results['mpeg4'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(602000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(1.92)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(25.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(405)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('mpeg4')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(720)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.7778)
      end
    end

    context 'of a h264 video (example 1)' do
      before do
        allow(subject).to receive(:process_cmd) { results['h264_1'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(1136000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(44.73)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(25.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(406)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (High)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(720)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.77339)
      end
    end

    context 'of a h264 video (example 2)' do
      before do
        allow(subject).to receive(:process_cmd) { results['h264_2'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(44100)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(1098000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(1187.76)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(24.93)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(350)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (Main)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(620)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.7714)
      end
    end

    context 'of a h264 video (example 3)' do
      before do
        allow(subject).to receive(:process_cmd) { results['h264_3'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(44100)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(951000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(8172.36)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(25)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(350)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (Main)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(620)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.7714)
      end
    end

    context 'of a h264 video (baseline example)' do
      before do
        allow(subject).to receive(:process_cmd) { results['h264_baseline'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(44100)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(953000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(103.08)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(25.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(350)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (Constrained Baseline)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(620)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.7714)
      end
    end

    context 'of a wmv video' do
      before do
        allow(subject).to receive(:process_cmd) { results['wmv'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('wmav2')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(44100)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(699000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(151.79)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(29.97)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(300)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('wmv3 (Main)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(400)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.33333)
      end
    end

    context 'of an avi video' do
      before do
        allow(subject).to receive(:process_cmd) { results['avi'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('mp3')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(2099000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(596.45)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(24.00)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(480)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('msmpeg4v2')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(854)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.779167)
      end
    end

    context 'of an avi video without audio track' do
      before do
        allow(subject).to receive(:process_cmd) { results['avi_without_audio'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        expect(@metadata[:audio_codec]).to be_nil
      end

      it 'should not extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to be_nil
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(1071000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(6.25)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(40.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(240)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('IV41')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(256)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.066667)
      end
    end

    context 'of an avi hypercam video without audio track' do
      before do
        allow(subject).to receive(:process_cmd) { results['avi_hypercam'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        expect(@metadata[:audio_codec]).to be_nil
      end

      it 'should not extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to be_nil
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(128000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(62.0)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(1.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(476)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('msvideo1')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(588)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.235294)
      end
    end

    context 'of a mkv video without bit rate' do
      before do
        allow(subject).to receive(:size) { 10000000 }
        allow(subject).to receive(:process_cmd) { results['mkv_without_bit_rate'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should calculate the bit rate from file size' do
        expect(@metadata[:bit_rate]).to eq(1752467)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(44.58)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(23.98)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(256)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (High)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(592)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to eq(2.3125)
      end
    end

    context 'of a ts video' do
      before do
        allow(subject).to receive(:process_cmd) { results['ts'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('mp2')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(5006000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(93.52)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(29.97)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(480)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('mpeg2video (Main)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(640)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.33333)
      end
    end

    context 'of a webm video without bit rate' do
      before do
        allow(subject).to receive(:size) { 2000000 }
        allow(subject).to receive(:process_cmd) { results['webm_without_bit_rate'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('vorbis')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(44100)
      end

      it 'should calculate the bit rate from file size' do
        expect(@metadata[:bit_rate]).to eq(2810252)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(5.56)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(30)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(314)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('vp8')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(558)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.77707)
      end
    end

    context 'of an ogg video' do
      before do
        allow(subject).to receive(:process_cmd) { results['ogg'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('vorbis')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(44100)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(504000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(64.93)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(29.97)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(240)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('theora')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(320)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.33333)
      end
    end

    context 'of a mxf video without audio' do
      before do
        allow(subject).to receive(:process_cmd) { results['mxf_without_audio'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        expect(@metadata[:audio_codec]).to be_nil
      end

      it 'should not extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to be_nil
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(2101000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(10.72)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(25.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(576)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('mpeg2video (Main)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(768)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.33333)
      end
    end

    context 'of a mjpg video' do
      before do
        allow(subject).to receive(:process_cmd) { results['mjpg'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('pcm_s16be')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(16000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(26751000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(20.50)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(30.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(720)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('mjpeg')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(1280)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.777778)
      end
    end

    context 'of an ivf video without audio track' do
      before do
        allow(subject).to receive(:process_cmd) { results['ivf_without_audio'] }
        @metadata = subject.data
      end

      it 'should not extract the audio codec' do
        expect(@metadata[:audio_codec]).to be_nil
      end

      it 'should not extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to be_nil
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(13983000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(10.0)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(50.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(1080)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('vp8')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(1920)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.777778)
      end
    end

    context 'of a mov video' do
      before do
        allow(subject).to receive(:process_cmd) { results['mov'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(3342000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(596.48)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(24.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(480)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (Main)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(854)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.779167)
      end
    end

    context 'of an anamorphic mpg video' do
      before do
        allow(subject).to receive(:process_cmd) { results['mpg_anamorphic'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('mp2')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(6300000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(105.84)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(25.0)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(576)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('mpeg2video (Main)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(1024)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.7778)
      end
    end

    context 'of a mts video' do
      before do
        allow(subject).to receive(:size) { 2000000 }
        allow(subject).to receive(:process_cmd) { results['mts'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('ac3')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(15815000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(254.91)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(50)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(1080)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (High)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(1920)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.77778)
      end
    end

    context 'of a Quicktime mp4 video' do
      before do
        allow(subject).to receive(:size) { 2000000 }
        allow(subject).to receive(:process_cmd) { results['qt_mp4'] }
        @metadata = subject.data
      end

      it 'should extract the audio codec' do
        expect(@metadata[:audio_codec]).to eq('aac')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:audio_sample_rate]).to eq(48000)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(1136000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(44.72)
      end

      it 'should extract frames per second' do
        expect(@metadata[:frame_rate]).to eq(25)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(406)
      end

      it 'should extract the video codec' do
        expect(@metadata[:video_codec]).to eq('h264 (High)')
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(720)
      end

      it 'should extract the aspect ratio' do
        expect(@metadata[:aspect_ratio]).to be_within(0.0001).of(1.7733)
      end
    end

    it "should raise DataError if metadata is invalid" do
      allow(subject).to receive(:process_cmd) {results["invalid_data"]}
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
        "mts" => "video/mts",
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
        allow(subject).to receive(:path) { "something.#{format}" }
        allow(subject).to receive(:format) { format }
        expect(subject.send(:content_type)).to eq(mime_types[format])
      end
    end
  end
end
