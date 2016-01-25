class Api::ApiController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :authenticate_user_from_token!

  private

  def authenticate_user_from_token!
    user_token = params[:user_token].presence
    user = user_token && User.find_by_token(user_token.to_s)

    if user
      sign_in user, store: false
    else
      render json: { error: 'please provide user token' }
    end
  end
end
