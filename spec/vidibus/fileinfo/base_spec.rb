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
      expect(subject.new(jpg_path)).to be_truthy
    end

    it "should allow access to the processor's methods" do
      expect(jpg_info).to respond_to(:data)
    end
  end

  describe "#format" do
    it "should return the current file's format" do
      allow(Vidibus::Fileinfo).to receive(:format).with(jpg_path) {"jpg"}
      jpg_info.format
    end
  end

  describe "#mime_type" do
    it "should return the current file's mime type" do
      expect(jpg_info.mime_type).to eq('image/jpeg')
    end

    it 'should return the wanted media type "video"' do
      allow(jpg_info).to receive(:path) { 'something.mp4' }
      allow(jpg_info).to receive(:format) { 'mp4' }
      expect(jpg_info.mime_type('video')).to eq('video/mp4')
    end

    it 'should return the wanted media type "audio"' do
      allow(jpg_info).to receive(:path) { 'something.mp4' }
      allow(jpg_info).to receive(:format) { 'mp4' }
      expect(jpg_info.mime_type('audio')).to eq('audio/mp4')
    end

    it 'should return alternative if wanted media type is not available' do
      allow(jpg_info).to receive(:path) { 'something.rm' }
      allow(jpg_info).to receive(:format) { 'rm' }
      expect(jpg_info.mime_type('video')).to eq('application/vnd.rn-realmedia')
    end

    it 'should be aliased as #content_type' do
      expect(jpg_info.send(:content_type)).to eq('image/jpeg')
    end
  end

  describe "#path" do
    it "should return the current file's path" do
      expect(jpg_info.path).to eql(jpg_path)
    end
  end

  describe "#processor" do
    it "should return the matching processor for given file" do
      expect(jpg_info.processor).to eql(Vidibus::Fileinfo::Processor::Image)
    end
  end
end
