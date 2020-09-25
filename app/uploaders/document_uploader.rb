require "image_processing/mini_magick"

class DocumentUploader < Shrine

  # include ImageProcessing::Vips

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


  # plugin :processing # allows hooking into promoting
  # plugin :versions   # enable Shrine to handle a hash of files
  # plugin :delete_raw # delete processed files after uploading


  # process(:store) do |io, context|
  #   versions = { original: io } # retain original

  #   io.download do |original|
  #     pipeline = ImageProcessing::Vips.source(original)
  #     pipeline = pipeline.convert("jpeg").saver(interlace: true)
  #     versions[:large]  = pipeline.resize_to_limit!(800, 800)
  #     versions[:medium] = pipeline.resize_to_limit!(500, 500)
  #     versions[:small]  = pipeline.resize_to_limit!(300, 300)
  #   end

  #   versions # return the hash of processed files
  # end

end