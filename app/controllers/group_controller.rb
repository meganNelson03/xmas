class GroupController < ApplicationController

  def index 
    @group = current_account.account_group
  end

end
