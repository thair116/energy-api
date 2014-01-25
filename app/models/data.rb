class Authorship < ActiveRecord::Base
  # belongs_to :article, touch: true
  belongs_to :series

  # belongs_to :author
end
