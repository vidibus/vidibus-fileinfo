def stub_file(path)
  allow(File).to receive(:exist?).with(path) { true }
  allow(File).to receive(:file?).with(path) { true }
end
