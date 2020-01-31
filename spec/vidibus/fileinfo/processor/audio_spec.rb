require "spec_helper"

describe Vidibus::Fileinfo::Processor::Audio do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp3_path)}
  let(:results) {load_fixture("audio_results")}

  describe "FORMATS" do
    it "should include various video formats" do
      formats = %w[mp3]
      expect(Vidibus::Fileinfo::Processor::Audio::FORMATS).to eq(formats)
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[codec sample_rate content_type bit_rate duration]
      expect(Vidibus::Fileinfo::Processor::Audio::METADATA).to eq(metadata)
    end
  end

  describe "#process_cmd" do
    it "should return raw metadata from an audio file" do
      expect(subject.data).not_to be_empty
    end
  end

  describe "#audio?" do
    it "returns true" do
      expect(subject.audio?).to be_truthy
    end
  end

  describe "#video?" do
    it "returns false" do
      expect(subject.video?).to be_falsey
    end
  end

  describe "#image?" do
    it "returns false" do
      expect(subject.image?).to be_falsey
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it 'should raise a DataError if "duration" validation fails' do
      allow(subject).to receive(:duration) { 0 }
      expect { subject.data }.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should include the content_type' do
      expect(subject.data[:content_type]).to eql('audio/mpeg')
    end

    context 'of a mp3 file' do
      before do
        allow(subject).to receive(:process_cmd) { results['mp3'] }
        @metadata = subject.data
      end

      it 'should extract the codec' do
        expect(@metadata[:codec]).to eq('mp3')
      end

      it 'should extract the audio sample rate' do
        expect(@metadata[:sample_rate]).to eq(44100)
      end

      it 'should extract the bit rate' do
        expect(@metadata[:bit_rate]).to eq(95000)
      end

      it 'should extract the duration in seconds' do
        expect(@metadata[:duration]).to eq(34.25)
      end
    end
  end

  describe '#content_type' do
    let(:mime_types) do
      {
        'mp3' => 'audio/mpeg'
      }
    end

    Vidibus::Fileinfo::Processor::Audio::FORMATS.each do |format|
      it "should be valid for '#{format}'" do
        allow(subject).to receive(:path) { "something.#{format}" }
        allow(subject).to receive(:format) { format }
        expect(subject.send(:content_type)).to eq(mime_types[format])
      end
    end
  end
end
