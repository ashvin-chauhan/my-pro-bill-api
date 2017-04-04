class UserMailer < ApplicationMailer
	
  def user_confirmation(resource)
  	@resource = resource
  	mail(to: @resource.email, subject: 'Account create successfully.')
  end

end