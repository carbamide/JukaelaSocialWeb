class Image
    def self.img
        if ENV['IMGUR'].nil?
            raise Exception, "Missing environment key for IMGUR API"
        end

        @img ||= Imgur::API.new ENV['IMGUR']
    end

    def self.small_thumbnail img_hash
        "http://imgur.com/#{img_hash}s.png"
    end

    def self.large_thumbnail img_hash
        "http://imgur.com/#{img_hash}l.png"
    end

    def self.original_image img_hash
        "http://imgur.com/#{img_hash}.png"
    end

    def self.imgur_page img_hash
        "http://imgur.com/#{img_hash}"
    end

    def self.upload file
        return '' if file.nil?
        filename = clean_filename file.original_filename
        tmp_file_path = File.join(Rails.root, 'tmp', filename)

        imgur = send_to_imgur(file, tmp_file_path)
        imgur['image_hash']
    end

    def self.send_to_imgur(file, tmp_file_path)
        FileUtils.mv file.tempfile.path, tmp_file_path
        imgur = img.upload_file tmp_file_path
        FileUtils.rm tmp_file_path
        imgur
    end

    def self.clean_filename filename
        file_name = filename.split(".").first.gsub!(/[^a-z0-9]+/i, '_')
        file_type = filename.split(".").last
        "#{file_name}.#{file_type}"
    end
end