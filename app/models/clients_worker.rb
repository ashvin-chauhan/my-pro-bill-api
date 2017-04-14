class ClientsWorker < ApplicationRecord
  acts_as_paranoid
  belongs_to :worker_client, class_name: "User", foreign_key: "client_id"
  belongs_to :worker, class_name: "User", foreign_key: "worker_id"
end
