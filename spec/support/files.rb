FILES_DIR = File.join(File.dirname(__FILE__), "..", "files")

def jpg_path
  @jpg_path ||= File.join(FILES_DIR, "wizard.jpg")
end

def mp4_path
  @mp4_path ||= File.join(FILES_DIR, "airplane.mp4")
end

def mp3_path
  @mp4_path ||= File.join(FILES_DIR, "part1.mp3")
end
