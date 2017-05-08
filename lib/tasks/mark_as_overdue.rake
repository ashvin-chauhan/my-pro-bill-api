desc "Mark invoices to overdue if invoice due_date is greater then today date"
task :mark_as_overdue => :environment do
  Invoice.mark_as_overdue
end
