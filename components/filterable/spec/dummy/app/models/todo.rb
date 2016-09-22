class Todo < ActiveRecord::Base
  extend Filterable

  scope :by_text,    ->(text)  { where(text: text) }
  scope :by_title,   ->(title) { where(title: title) }
  scope :by_number,  ->(num)   { where(number_id: num) }
end
