class Account < ApplicationRecord
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  # has_one :list, dependent: :destroy
  has_many :lists, dependent: :destroy

  has_many :accounts_groups, dependent: :delete_all
  has_many :groups, through: :accounts_groups
  has_many :membership_requests, dependent: :delete_all

  default_scope { order(first_name: :asc) } 

  after_create :create_list 

  aasm column: :status do
    state :inactive, initial: true
    state :invited
    state :active 

    event :invite do
      transitions from: :inactive, to: :invited 
    end

    event :active do
      transitions from: :inactive, to: :active
      transitions from: :invited, to: :active 
    end
  end 

  def current_group
    return Group.none if current_group_id.blank?
    
    groups.find_by(id: current_group_id)
  end

  def current_list 
    return if current_group.blank? 

    lists.find_by(group_id: current_group.id)
  end

  def shares_group?(account)
    account.grouped? && (account.group_id == group_id)
  end

  def in_group?(group)
    groups.include?(group)
  end

  def has_many_groups?
    groups.count > 1
  end

  def requested?(group)
    membership_requests.where(group_id: group.id).present?
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def formatted_name 
    return if first_name.blank? || last_name.blank? 

    [first_name, last_name.first + "."].join(" ")
  end

  def grouped?
    groups.present?
  end

  def members_in_selected_group(group)
    return Account.none if group.blank?

    group.accounts.where(status: 'active')
  end

  def self.from_google(u)
    create_with(uid: u[:uid], provider: 'google',
                password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  end

  def password_required?
    false
  end

  private

  def create_list 
    List.create(account_id: id)
  end
end
