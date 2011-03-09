require "spec_helper"

describe Vidibus::Fileinfo::Processor::Image do
  let(:subject) {Vidibus::Fileinfo::Base.new(jpg_path)}

  describe "FORMATS" do
    it "should include various image formats" do
      Vidibus::Fileinfo::Processor::Image::FORMATS.should eql(%w[jpg jpeg png gif])
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it "should raise an error if ImageMagick fails to extract any data" do
      stub(subject).perform {""}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise an error if ImageMagick fails to extract dimensions" do
      stub(subject).perform {"Something"}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should return a hash of image attributes" do
      subject.data.should eql({
        :content_type => "jpeg",
        :width => 30,
        :height => 23,
        :bit => 8,
        :size => 14822
      })
    end
  end
end
