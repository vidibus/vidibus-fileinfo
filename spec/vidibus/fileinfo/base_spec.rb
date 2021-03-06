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
      jpg_info.mime_type.should eq('image/jpeg')
    end

    it 'should return the wanted media type "video"' do
      stub(jpg_info).path { 'something.mp4' }
      stub(jpg_info).format { 'mp4' }
      jpg_info.mime_type('video').should eq('video/mp4')
    end

    it 'should return the wanted media type "audio"' do
      stub(jpg_info).path { 'something.mp4' }
      stub(jpg_info).format { 'mp4' }
      jpg_info.mime_type('audio').should eq('audio/mp4')
    end

    it 'should return alternative if wanted media type is not available' do
      stub(jpg_info).path { 'something.rm' }
      stub(jpg_info).format { 'rm' }
      jpg_info.mime_type('video').should eq('application/vnd.rn-realmedia')
    end

    it 'should be aliased as #content_type' do
      jpg_info.send(:content_type).should eq('image/jpeg')
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
