require "spec_helper"

describe Vidibus::Fileinfo::Processor::Video do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp4_path)}

  describe "FORMATS" do
    it "should include various video formats" do
      formats = %w[avi flv h261 h263 h264 ipod m4v mov mp4 mpeg mxf ogg]
      Vidibus::Fileinfo::Processor::Video::FORMATS.should eq(formats)
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[audio_codec audio_sample_rate bitrate duration fps
        height size video_codec width]
      Vidibus::Fileinfo::Processor::Video::METADATA.should eq(metadata)
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it "should raise DataError if height is 0" do
      stub(subject).height {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise DataError if width is 0" do
      stub(subject).width {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise DataError if duration is 0" do
      stub(subject).duration {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise DataError if a metadata method raised an exception" do
      stub(subject).dimension {nil}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should return a hash of correct video attributes" do
      attr = {
        :video_codec => "mpeg4",
        :audio_codec => "aac",
        :audio_sample_rate => 48000,
        :height => 405,
        :width => 720,
        :fps => 25.0,
        :duration => 1.92,
        :bitrate => 602,
        :size => 144631
      }
      subject.data.should eq(attr)
    end
  end
end
