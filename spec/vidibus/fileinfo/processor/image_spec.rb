require "spec_helper"

describe Vidibus::Fileinfo::Processor::Image do
  let(:subject) {Vidibus::Fileinfo::Base.new(jpg_path)}
  let(:results) {load_fixture('image_results')}

  describe "FORMATS" do
    it "should include various image formats" do
      Vidibus::Fileinfo::Processor::Image::FORMATS.should eql(%w[jpg jpeg png gif])
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[bit content_type height orientation quality size width]
      Vidibus::Fileinfo::Processor::Image::METADATA.should eq(metadata)
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it "should raise an error if height is 0" do
      stub(subject).height {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise an error if width is 0" do
      stub(subject).width {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    context 'of a jfif image' do
      before do
        stub(subject).process_cmd { results['jfif'] }
        @metadata = subject.data
      end

      it 'should extract the bit depth' do
        @metadata[:bit].should eq(8)
      end

      it 'should extract the width' do
        @metadata[:width].should eq(1280)
      end

      it 'should extract the height' do
        @metadata[:height].should eq(720)
      end
    end
  end

  describe "#process_cmd" do
    it "should return raw metadata from an image" do
      subject.data.should_not be_empty
    end
  end

  it "should return a hash of correct image metadata" do
    metadata = {
      :content_type => 'image/jpeg',
      :width => 200,
      :height => 194,
      :bit => 8,
      :orientation => 6,
      :quality => 92,
      :size => 37958
    }
    subject.data.should eq(metadata)
  end
end
