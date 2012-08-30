class ProgramPhotoImportTag < ActiveRecord::Base
  belongs_to :program
  attr_accessible :program_id, :tag

  validates :tag, presence: true, length: { maximum: 50 }

  def object_label
    "##{self.tag}"
  end
end
