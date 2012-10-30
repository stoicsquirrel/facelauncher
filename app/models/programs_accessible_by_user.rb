class ProgramsAccessibleByUser < ActiveRecord::Base
  belongs_to :program
  belongs_to :user

  attr_accessible :program_id, :user_id
end
