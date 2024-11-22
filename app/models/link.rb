class Link < ApplicationRecord
  belongs_to :list_item
  validate :valid_url


  private

  def valid_url 
    return if url.blank?
    return if url =~ URI::regexp

    if !(url.starts_with?('http://') || url.starts_with?('https://'))
      errors.add(:url, " must include http:// or https://") 
    else
      errors.add(:url, ' is not valid')
    end
  end
end
