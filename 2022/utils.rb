module Utils
  class FileReader
    def read_file(file_path, &block)
      f = File.open(file_path, "r")
      f.each_line do |line|
        block.call line
      end
      f.close
    end
  end
end
