class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one :list, dependent: :destroy

  belongs_to :account_group, optional: true

  after_create :create_list 

  def shares_group?(account)
    account.grouped? && (account.account_group_id == account_group_id)
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def grouped?
    account_group.present?
  end

  def groupies
    return Account.none if account_group.blank?
    account_group.accounts 
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
