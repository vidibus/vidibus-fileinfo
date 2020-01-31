require "spec_helper"
require "ostruct"

describe Vidibus::Fileinfo do
  let(:subject) {Vidibus::Fileinfo}

  describe ".processors" do
    it "should return a list of available processor classes" do
      expect(subject.processors).to eql([Vidibus::Fileinfo::Processor::Image, Vidibus::Fileinfo::Processor::Video, Vidibus::Fileinfo::Processor::Audio])
    end
  end

  describe ".formats" do
    it "should return a list of processable file formats" do
      expect(subject.formats).to eql(%w[3g2 3gp asf avi dv f4p f4v flv gif ivf jpeg jpg m21 mj2 mjpg mkv mov mp3 mp4 mpeg mpg mts mxf ogg ogv png rm ts webm wmv])
    end
  end

  describe ".processor" do
    it "should require a format" do
      expect {subject.processor}.to raise_error(ArgumentError)
    end

    it "should return the image processor for an image format" do
      expect(subject.processor("jpg")).to eql(Vidibus::Fileinfo::Processor::Image)
    end

    it "should return the video processor for a video format" do
      expect(subject.processor("mp4")).to eql(Vidibus::Fileinfo::Processor::Video)
    end

    it "should raise an error for unsupported file formats" do
      expect {
        subject.processor("xxx")
      }.to raise_error(Vidibus::Fileinfo::UnsupportedFormatError)
    end
  end

  describe ".format" do
    it "should require a path" do
      expect {subject.format}.to raise_error(ArgumentError)
    end

    it "should return the format of a given file path" do
      expect(subject.format("/my/face.jpg")).to eql("jpg")
    end

    it "should return the format in lower case" do
      expect(subject.format("/my/face.JPG")).to eql("jpg")
    end

    it "should raise an error if no format can be detected" do
      expect {
        subject.format("/my/face")
      }.to raise_error(Vidibus::Fileinfo::NoFormatError)
    end
  end

  describe ".bytes" do
    it "should require a value" do
      expect {subject.bytes}.to raise_error(ArgumentError)
    end

    it "should return input number" do
      expect(subject.bytes(1)).to eql(1)
    end

    it "should return a rounded input float" do
      expect(subject.bytes(1.5)).to eql(2)
    end

    it "should parse '18942'" do
      expect(subject.bytes("18942")).to eql(18942)
    end

    it "should parse '135 B'" do
      expect(subject.bytes("135 B")).to eql(135)
    end

    it "should parse '1 kB'" do
      expect(subject.bytes("1 kB")).to eql(1024)
    end

    it "should parse '2KB'" do
      expect(subject.bytes("2KB")).to eql(2048)
    end

    it "should parse '2.4k'" do
      expect(subject.bytes("2.4k")).to eql(2458)
    end

    it "should parse '0.23 MB'" do
      expect(subject.bytes("0.23 MB")).to eql(241172)
    end

    it "should parse '5 M'" do
      expect(subject.bytes("5 M")).to eql(5242880)
    end

    it "should parse '1.4gb'" do
      expect(subject.bytes("1.4482gb")).to eql(1554992910)
    end

    it "should parse '4G'" do
      expect(subject.bytes("4G")).to eql(4294967296)
    end

    it "should parse '0.0002 TB'" do
      expect(subject.bytes("0.0002 TB")).to eql(219902326)
    end

    it "should parse '4t'" do
      expect(subject.bytes("4t")).to eql(4398046511104)
    end

    it "should raise an error for unsupported values" do
      expect {subject.bytes([4.5])}.to raise_error(ArgumentError)
    end

    it "should raise an error for unsupported units" do
      expect {subject.bytes("5.2 flop/s")}.to raise_error(Vidibus::Fileinfo::UnitError)
    end
  end
end

describe "Fileinfo" do
  it "should be a shorthand for Vidibus::Fileinfo::Base.new and return file data" do
    allow(Vidibus::Fileinfo::Base).to receive(:new).with("/my/face.jpg") { OpenStruct.new }
    allow_any_instance_of(OpenStruct).to receive(:data) { {some: "thing"} }
    expect(Fileinfo("/my/face.jpg")).to eq({some: "thing"})
  end
end
