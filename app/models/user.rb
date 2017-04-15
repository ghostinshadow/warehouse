class User < ApplicationRecord
  enum role: [:guest, :user, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_many :activities

  def set_default_role
    self.role ||= :guest
  end

  def has_role?(role)
    self.role == role.to_s
  end

  def approve!
    return unless guest?
    self.role = :user
    self.save
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
