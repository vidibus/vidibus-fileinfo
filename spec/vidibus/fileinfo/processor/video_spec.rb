require "spec_helper"

describe Vidibus::Fileinfo::Processor::Video do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp4_path)}

  describe "FORMATS" do
    it "should include various image formats" do
      Vidibus::Fileinfo::Processor::Video::FORMATS.should eql(%w[avi flv h261 h263 h264 ipod m4v mov mp4 mpeg mxf ogg])
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it "should call RVideo::Inspector.new" do
      mock(RVideo::Inspector).new(:file => mp4_path) {OpenStruct.new(:width => "10", :height => "10", :duration => "10")}
      subject.data
    end

    it "should raise an error if RVideo::Inspector returns nothing" do
      stub(RVideo::Inspector).new(:file => mp4_path) {}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise an error if RVideo::Inspector fails to extract height" do
      stub(RVideo::Inspector).new(:file => mp4_path) {OpenStruct.new(:width => "10", :height => nil, :duration => "10")}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise an error if RVideo::Inspector fails to extract width" do
      stub(RVideo::Inspector).new(:file => mp4_path) {OpenStruct.new(:width => nil, :height => "10", :duration => "10")}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise an error if RVideo::Inspector fails to extract duration" do
      stub(RVideo::Inspector).new(:file => mp4_path) {OpenStruct.new(:width => "10", :height => "10", :duration => nil)}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should return a hash of image attributes" do
      subject.data.should eql({
        :video_codec => "mpeg4",
        :audio_codec => "aac",
        :audio_sample_rate => 48000,
        :height => 405,
        :width => 720,
        :fps => 25.0,
        :duration => 1.92,
        :bitrate => 602,
        :size => 144631
      })
    end
  end
end
