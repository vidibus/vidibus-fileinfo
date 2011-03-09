def stub_file(path)
  stub(File).exist?(path) {true}
  stub(File).file?(path) {true}
end
