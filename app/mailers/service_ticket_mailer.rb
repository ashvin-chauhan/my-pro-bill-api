class ServiceTicketMailer < ApplicationMailer
	def notify_customer(service_ticket,customer,client)
		@service_ticket = service_ticket
		@customer = customer
		@client = client
		mail(to: @client.email, subject: 'Service Created Notification')
	end
end
