require 'vips'

module MockFile 
    def mock_jpg(size)
        image = Vips::Image.black(10, 10)
        temp_image_path = Tempfile.new(["image", ".jpg"]).path
        image.jpegsave(temp_image_path)
            
        current_size = File.size(temp_image_path)
        padding_size = size - current_size
        raise ArgumentError, 'Target size is too small for a valid JPG' if padding_size < 0
      
        File.open(temp_image_path, 'ab') { |f| f.write("\x00" * padding_size) }
      
        StringIO.new(File.binread(temp_image_path))
    end
end
