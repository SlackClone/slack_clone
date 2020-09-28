class AvatarUploader < ApplicationUploader
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { 
      small:  magick.resize_to_limit!(40, 40),
      medium: magick.resize_to_limit!(100, 100),
      large:  magick.resize_to_limit!(300, 300),
    }
  end
end

