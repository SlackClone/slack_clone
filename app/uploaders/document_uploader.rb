require "image_processing/mini_magick"

class DocumentUploader < Shrine

  Attacher.validate do
    validate_max_size 30*1024*1024, message: "is too large (max is 30 MB)"
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { 
      large:  magick.resize_to_limit!(800, 800),
      medium: magick.resize_to_limit!(500, 500),
      small:  magick.resize_to_limit!(300, 300),
    }
  end

  def generate_location(io, context)
    "documents/#{Time.now.to_i}/#{super}"
  end

end