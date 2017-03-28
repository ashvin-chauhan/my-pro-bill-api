module CustomTokenResponse
  def body
    user_details = { user: User.find(@token.resource_owner_id).as_json }
    # call original `#body` method and merge its result with the additional data hash
    super.merge(user_details)
  end
end