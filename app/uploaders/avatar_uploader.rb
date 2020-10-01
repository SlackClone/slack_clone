class AvatarUploader < ApplicationUploader
  
  Attacher.derivatives do |original,crop:nil|
    magick = ImageProcessing::MiniMagick.source(original)
    # 剪裁後的圖片
    magick = magick.crop("#{crop[:w]}x#{crop[:h]}+#{crop[:x]}+#{crop[:y]}")
    { 
      small:  magick.resize_to_limit!(32, 32),
      medium:  magick.resize_to_limit!(100,100),
      large:  magick.resize_to_limit!(300, 300)
    }
  end
end

