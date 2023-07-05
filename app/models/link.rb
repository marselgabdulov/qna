class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    url.include?('gist.github.com')
  end

  def parse_gist_id
    url.split('/').last
  end
end
