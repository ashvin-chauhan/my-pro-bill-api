class PdfGenerator
  attr_accessor :action, :view, :resource
  def initialize(attributes = {})
    @action = attributes[:action]
    @view = attributes[:view]
    @resource = attributes[:resource]
  end

  def call
    pdf = WickedPdf.new.pdf_from_string(
            find_html,
            :handlers => [:erb],
            :disable_smart_shrinking => true,
          )
    save_pdf(pdf)

    pdf
  end

  private

  def find_html
    html = File.read(Rails.root.join('app', 'views', action, view.to_s + '.html.erb'))
    html = ERB.new(html).result(binding)
    html
  end

  # Save generated pdf in public directory
  def save_pdf(pdf)
    CommonService.create_folder("invoices")
    save_path = Rails.root.join('public/invoices',"invoice#{resource.id}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end
end