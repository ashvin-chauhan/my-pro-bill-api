module CustomTokenResponse
  def body
    user_details = User.find(@token.resource_owner_id).as_json(include: [:roles])
    # call original `#body` method and merge its result with the additional data hash
    { success: true, message: "", data: { token: super, user: user_details }, errors: [] }
  end
end