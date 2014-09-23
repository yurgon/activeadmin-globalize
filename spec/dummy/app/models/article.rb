class Article < ActiveRecord::Base
  # Translated fields with globalize and for active admin
  active_admin_translates :title, :body

end
