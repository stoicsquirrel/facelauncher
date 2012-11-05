class User < ActiveRecord::Base
  has_many :programs_accessible_by_users, inverse_of: :user
	has_many :programs, through: :programs_accessible_by_users

	ROLES = %w[admin moderator]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :role, :program_ids
  # attr_accessible :title, :body
end
