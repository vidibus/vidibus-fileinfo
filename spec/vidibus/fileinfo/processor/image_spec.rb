require "spec_helper"

describe Vidibus::Fileinfo::Processor::Image do
  let(:subject) {Vidibus::Fileinfo::Base.new(jpg_path)}
  let(:results) {load_fixture('image_results')}

  describe "FORMATS" do
    it "should include various image formats" do
      expect(Vidibus::Fileinfo::Processor::Image::FORMATS).to eql(%w[jpg jpeg png gif])
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[bit content_type height orientation quality size width]
      expect(Vidibus::Fileinfo::Processor::Image::METADATA).to eq(metadata)
    end
  end

  describe "#audio?" do
    it "returns false" do
      expect(subject.audio?).to be_falsey
    end
  end

  describe "#video?" do
    it "returns false" do
      expect(subject.video?).to be_falsey
    end
  end

  describe "#image?" do
    it "returns true" do
      expect(subject.image?).to be_truthy
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it "should raise an error if height is 0" do
      allow(subject).to receive(:height) {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it "should raise an error if width is 0" do
      allow(subject).to receive(:width) { 0 }
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    context 'of a jfif image' do
      before do
        allow(subject).to receive(:process_cmd) { results['jfif'] }
        @metadata = subject.data
      end

      it 'should extract the bit depth' do
        expect(@metadata[:bit]).to eq(8)
      end

      it 'should extract the width' do
        expect(@metadata[:width]).to eq(1280)
      end

      it 'should extract the height' do
        expect(@metadata[:height]).to eq(720)
      end
    end
  end

  describe "#process_cmd" do
    it "should return raw metadata from an image" do
      expect(subject.data).not_to be_empty
    end
  end

  it "should return a hash of correct image metadata" do
    metadata = {
      :content_type => 'image/jpeg',
      :width => 200,
      :height => 194,
      :bit => 8,
      :orientation => "RightTop",
      :quality => 92,
      :size => 37958
    }
    expect(subject.data).to eq(metadata)
  end
end
