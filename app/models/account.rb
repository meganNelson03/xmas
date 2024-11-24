class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one :list, dependent: :destroy

  # belongs_to :group, optional: true
  has_many :accounts_groups
  has_many :groups, through: :accounts_groups

  after_create :create_list 

  def shares_group?(account)
    account.grouped? && (account.group_id == group_id)
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def grouped?
    groups.present?
  end

  def groupies
    return Account.none if groups.blank?
    groups.first.accounts 
  end

  def self.from_google(u)
    create_with(uid: u[:uid], provider: 'google',
                password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  end

  private

  def create_list 
    List.create(account_id: id)
  end
end
