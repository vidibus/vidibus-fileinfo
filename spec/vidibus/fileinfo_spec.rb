require "spec_helper"
require "ostruct"

describe Vidibus::Fileinfo do
  let(:subject) {Vidibus::Fileinfo}

  describe ".processors" do
    it "should return a list of available processor classes" do
      subject.processors.should eql([Vidibus::Fileinfo::Processor::Image, Vidibus::Fileinfo::Processor::Video])
    end
  end

  describe ".formats" do
    it "should return a list of processable file formats" do
      subject.formats.should eql(%w[avi flv gif h261 h263 h264 ipod jpeg jpg m4v mov mp4 mpeg mxf ogg png])
    end
  end

  describe ".processor" do
    it "should require a format" do
      expect {subject.processor}.to raise_error(ArgumentError)
    end

    it "should return the image processor for an image format" do
      subject.processor("jpg").should eql(Vidibus::Fileinfo::Processor::Image)
    end

    it "should return the video processor for a video format" do
      subject.processor("mp4").should eql(Vidibus::Fileinfo::Processor::Video)
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
      subject.format("/my/face.jpg").should eql("jpg")
    end

    it "should return the format in lower case" do
      subject.format("/my/face.JPG").should eql("jpg")
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
      subject.bytes(1).should eql(1)
    end

    it "should return a rounded input float" do
      subject.bytes(1.5).should eql(2)
    end

    it "should parse '18942'" do
      subject.bytes("18942").should eql(18942)
    end

    it "should parse '135 B'" do
      subject.bytes("135 B").should eql(135)
    end

    it "should parse '1 kB'" do
      subject.bytes("1 kB").should eql(1024)
    end

    it "should parse '2KB'" do
      subject.bytes("2KB").should eql(2048)
    end

    it "should parse '2.4k'" do
      subject.bytes("2.4k").should eql(2458)
    end

    it "should parse '0.23 MB'" do
      subject.bytes("0.23 MB").should eql(241172)
    end

    it "should parse '5 M'" do
      subject.bytes("5 M").should eql(5242880)
    end

    it "should parse '1.4gb'" do
      subject.bytes("1.4482gb").should eql(1554992910)
    end

    it "should parse '4G'" do
      subject.bytes("4G").should eql(4294967296)
    end

    it "should parse '0.0002 TB'" do
      subject.bytes("0.0002 TB").should eql(219902326)
    end

    it "should parse '4t'" do
      subject.bytes("4t").should eql(4398046511104)
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
    mock(Vidibus::Fileinfo::Base).new("/my/face.jpg") {OpenStruct.new}
    stub.any_instance_of(OpenStruct).data {{:some => "thing"}}
    Fileinfo("/my/face.jpg").should eql({:some => "thing"})
  end
end
