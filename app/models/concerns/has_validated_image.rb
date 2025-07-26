module HasValidatedImage
  extend ActiveSupport::Concern

  class_methods do
    def validates_image(name, max_size: 5.megabytes)
      validate do
        attachment = send(name)
        allowed_filetypes = ["image/png", "image/jpg", "image/jpeg"]
        if attachment.attached?
          if max_size && attachment.blob.byte_size > max_size
            attachment.purge
            errors.add(name, "size must be less than #{max_size / 1.megabyte}MB")
          elsif !allowed_filetypes.include?(attachment.blob.content_type) 
            attachment.purge
            errors.add(name, "must be an image")
          end
        end
      end
    end
  end
end