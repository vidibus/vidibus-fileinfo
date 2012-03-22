require "spec_helper"

describe Vidibus::Fileinfo::Processor::Video do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp4_path)}
  let(:results) {load_fixture("video_results")}

  describe "FORMATS" do
    it "should include various video formats" do
      formats = %w[avi flv h261 h263 h264 ipod m4v mov mp4 mpeg mxf ogg]
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

    it "should parse metadata correctly (mpeg4)" do
      stub(subject).process_cmd {results["mpeg4"]}
      metadata = subject.data
      metadata[:audio_codec].should       eq("aac")
      metadata[:audio_sample_rate].should eq(48000)
      metadata[:bitrate].should           eq(602)
      metadata[:duration].should          eq(1.92)
      metadata[:fps].should               eq(25.0)
      metadata[:height].should            eq(405)
      metadata[:video_codec].should       eq("mpeg4")
      metadata[:width].should             eq(720)
    end

    it "should parse metadata correctly (h264 1)" do
      stub(subject).process_cmd {results["h264_1"]}
      metadata = subject.data
      metadata[:audio_codec].should       eq("aac")
      metadata[:audio_sample_rate].should eq(48000)
      metadata[:bitrate].should           eq(1136)
      metadata[:duration].should          eq(44.73)
      metadata[:fps].should               eq(25.0)
      metadata[:height].should            eq(406)
      metadata[:video_codec].should       eq("h264 (High)")
      metadata[:width].should             eq(720)
    end

    it "should parse metadata correctly (h264 2)" do
      stub(subject).process_cmd {results["h264_2"]}
      metadata = subject.data
      metadata[:audio_codec].should       eq("aac")
      metadata[:audio_sample_rate].should eq(44100)
      metadata[:bitrate].should           eq(1098)
      metadata[:duration].should          eq(1187.76)
      metadata[:fps].should               eq(24.93)
      metadata[:height].should            eq(350)
      metadata[:video_codec].should       eq("h264 (Main)")
      metadata[:width].should             eq(620)
    end

    it "should parse metadata correctly (h264 3)" do
      stub(subject).process_cmd {results["h264_3"]}
      metadata = subject.data
      metadata[:audio_codec].should       eq("aac")
      metadata[:audio_sample_rate].should eq(44100)
      metadata[:bitrate].should           eq(951)
      metadata[:duration].should          eq(8172.36)
      metadata[:fps].should               eq(25.0)
      metadata[:height].should            eq(350)
      metadata[:video_codec].should       eq("h264 (Main)")
      metadata[:width].should             eq(620)
    end

    it "should parse metadata correctly (h264 baseline)" do
      stub(subject).process_cmd {results["h264_baseline"]}
      metadata = subject.data
      metadata[:audio_codec].should       eq("aac")
      metadata[:audio_sample_rate].should eq(44100)
      metadata[:bitrate].should           eq(953)
      metadata[:duration].should          eq(103.08)
      metadata[:fps].should               eq(25.0)
      metadata[:height].should            eq(350)
      metadata[:width].should             eq(620)
      metadata[:video_codec].should       eq("h264 (Constrained Baseline)")
    end

    it "should raise DataError if metadata is invalid" do
      stub(subject).process_cmd {results["invalid_data"]}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end
  end
end
