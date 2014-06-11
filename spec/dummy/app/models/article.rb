class Article < ActiveRecord::Base
  attr_accessible :body, :title

  translates :title, :body
end
