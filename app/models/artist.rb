class Artist < ActiveRecord::Base
    has_many :songs 
    has_many :genres, through: :songs

    def slug 
        self.name.strip.gsub(/[\s\t\r\n\f]/,'-').gsub(/\W/,'-').downcase
    end

    def self.find_by_slug(slug)
        self.all.detect {|artist| artist.slug == slug}
    end
end