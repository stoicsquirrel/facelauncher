class Signup < ActiveRecord::Base
  belongs_to :program

  serialize :fields, ActiveRecord::Coders::Hstore
  attr_accessor :program_access_key
  attr_accessible :program_id, :address1, :address2, :city, :email,
                  :first_name, :last_name, :state, :status, :zip,
                  :facebook_user_id, :is_valid, :program_access_key,
                  :ip_address, :country

  validates :program, presence: true
  validates :email, presence: true, length: { maximum: 100 }
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :city, length: { maximum: 40 }
  validates :zip, length: { maximum: 9 }
  validates :facebook_user_id, length: { maximum: 25 }

  def validate_program_access_key
    if program_access_key.blank?
      errors.add(:program_access_key, "is missing.")
    elsif program_access_key != program.program_access_key
      errors.add(:program_access_key, "is invalid.")
    end
  end

  all_fields_keys = ActiveRecord::Base.connection.execute("SELECT DISTINCT UNNEST(akeys(fields)) AS key FROM signups ORDER BY key").map {|f| f['key']}
  all_fields_keys.each do |key|
    attr_accessible key
    scope "has_#{key}", lambda {|value| where("fields @> (? => ?)", key, value)}

    define_method(key) do
      fields && fields[key]
    end

    define_method("#{key}=") do |value|
      self.fields = (fields || {}).merge(key => value)
    end
  end

  def fields_keys
    if !self.program_id.nil?
      @fields_keys = ActiveRecord::Base.connection.execute("SELECT DISTINCT UNNEST(akeys(fields)) AS key FROM signups WHERE signups.program_id = #{self.program_id} ORDER BY key").map {|f| f['key']}
    else
      @fields_keys = ActiveRecord::Base.connection.execute("SELECT DISTINCT UNNEST(akeys(fields)) AS key FROM signups ORDER BY key").map {|f| f['key']}
    end
  end

  def validate
    self.update_attributes(is_valid: true)
  end

  def invalidate
    self.update_attributes(is_valid: false)
  end

end
