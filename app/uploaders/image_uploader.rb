class ImageUploader < ApplicationUploader
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { 
      small:  magick.resize_to_limit!(40, 40),
    }
  end
end