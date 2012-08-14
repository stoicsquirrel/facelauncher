class AdditionalField < ActiveRecord::Base
  belongs_to :program
  attr_accessible :is_required, :name
end
