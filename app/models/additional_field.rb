class AdditionalField < ActiveRecord::Base
  belongs_to :program
  attr_accessible :is_required, :short_name, :label, :program_id

  validates :program, presence: true

  private
  def object_label
    short_name.humanize
  end
end
