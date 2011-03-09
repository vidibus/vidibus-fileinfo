require "spec_helper"

describe Vidibus::Fileinfo::Base do
  let(:subject) {Vidibus::Fileinfo::Base}
  let(:jpg_info) {subject.new(jpg_path)}

  describe "initializing" do
    it "should require one param" do
      expect {subject.new}.to raise_error(ArgumentError)
    end

    it "should raise an error if file is not accessible" do
      expect {
        subject.new("something")
      }.to raise_error(Vidibus::Fileinfo::FileAccessError)
    end

    it "should raise an error if file is a directory" do
      expect {
        subject.new(File.dirname(__FILE__))
      }.to raise_error(Vidibus::Fileinfo::NoFileError)
    end

    it "should raise an error if file format is not supported" do
      stub_file("/what.ever")
      expect {
        subject.new("/what.ever")
      }.to raise_error(Vidibus::Fileinfo::UnsupportedFormatError)
    end

    it "should pass if file is valid" do
      subject.new(jpg_path).should be_true
    end

    it "should allow access to the processor's methods" do
      jpg_info.should respond_to(:data)
    end
  end

  describe "#format" do
    it "should return the current file's format" do
      mock(Vidibus::Fileinfo).format(jpg_path) {"jpg"}
      jpg_info.format
    end
  end

  describe "#mime_type" do
    it "should return the current file's mime type" do
      mock(Mime::Type).lookup_by_extension("jpg") {"image/jpeg"}
      jpg_info.mime_type
    end
  end

  describe "#path" do
    it "should return the current file's path" do
      jpg_info.path.should eql(jpg_path)
    end
  end

  describe "#processor" do
    it "should return the matching processor for given file" do
      jpg_info.processor.should eql(Vidibus::Fileinfo::Processor::Image)
    end
  end
end
