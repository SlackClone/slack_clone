require "image_processing/mini_magick"

class ImageUploader < Shrine

  Attacher.validate do
    validate_max_size 5*1024*1024, message: "is too large (max is 5 MB)"
    validate_mime_type %w[image/jpeg image/png image/webp], message: "Wrong data type"
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { 
      large:  magick.resize_to_limit!(800, 800),
      medium: magick.resize_to_limit!(500, 500),
      small:  magick.resize_to_limit!(300, 300),
    }
  end

end