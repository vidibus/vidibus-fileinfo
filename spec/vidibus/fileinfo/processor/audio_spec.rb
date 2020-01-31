require "spec_helper"

describe Vidibus::Fileinfo::Processor::Audio do
  let(:subject) {Vidibus::Fileinfo::Base.new(mp3_path)}
  let(:results) {load_fixture("audio_results")}

  describe "FORMATS" do
    it "should include various video formats" do
      formats = %w[mp3]
      Vidibus::Fileinfo::Processor::Audio::FORMATS.should eq(formats)
    end
  end

  describe "METADATA" do
    it "should include various metadata attributes" do
      metadata = %w[codec sample_rate content_type bit_rate duration]
      Vidibus::Fileinfo::Processor::Audio::METADATA.should eq(metadata)
    end
  end

  describe "#process_cmd" do
    it "should return raw metadata from an audio file" do
      subject.data.should_not be_empty
    end
  end

  describe "#audio?" do
    it "returns true" do
      subject.audio?.should be_true
    end
  end

  describe "#video?" do
    it "returns false" do
      subject.video?.should be_false
    end
  end

  describe "#image?" do
    it "returns false" do
      subject.image?.should be_false
    end
  end

  describe "#data" do
    it "should require @path to be defined" do
      subject.instance_variable_set("@path", nil)
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::PathError)
    end

    it 'should raise a DataError if "duration" validation fails' do
      stub(subject).duration {0}
      expect {subject.data}.to raise_error(Vidibus::Fileinfo::DataError)
    end

    it 'should include the content_type' do
      subject.data[:content_type].should eql('audio/mpeg')
    end

    context 'of a mp3 file' do
      before do
        stub(subject).process_cmd { results['mp3'] }
        @metadata = subject.data
      end

      it 'should extract the codec' do
        @metadata[:codec].should eq('mp3')
      end

      it 'should extract the audio sample rate' do
        @metadata[:sample_rate].should eq(44100)
      end

      it 'should extract the bit rate' do
        @metadata[:bit_rate].should eq(95000)
      end

      it 'should extract the duration in seconds' do
        @metadata[:duration].should eq(34.25)
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
        stub(subject).path { "something.#{format}" }
        stub(subject).format { format }
        subject.send(:content_type).should eq(mime_types[format])
      end
    end
  end
end
