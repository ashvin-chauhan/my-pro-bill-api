class ServiceTicket < ApplicationRecord
  acts_as_paranoid
  belongs_to :customer, :class_name => "User"
  belongs_to :created_by, :class_name => "User"
  belongs_to :client, :class_name => "User"
  has_many :service_ticket_items, dependent: :destroy
  accepts_nested_attributes_for :service_ticket_items, allow_destroy: true

  enum status: { unprocessed: 0 }

  after_create_commit :send_notification, only: [:create]

  # Send notification mail and text to customer

  def send_notification
    if self.customer.customer.service_notifications.count > 1
      ServiceTicketMailer.delay.notify_customer(self, self.customer, self.client)
      # integrate SMS API
    elsif self.customer.customer.service_notifications.include? 'Email'
      ServiceTicketMailer.delay.notify_customer(self, self.customer, self.client)
    elsif self.customer.customer.service_notifications.include? 'Text'
      # integrate SMS API
    end
  end

end
