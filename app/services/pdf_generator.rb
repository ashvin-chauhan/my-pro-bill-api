class PdfGenerator
  attr_accessor :action, :view, :resource
  def initialize(attributes = {})
    @action = attributes[:action]
    @view = attributes[:view]
    @resource = attributes[:resource]
  end

  def send
    pdf = WickedPdf.new.pdf_from_string(
            find_html,
            :handlers => [:erb],
            :disable_smart_shrinking => true,
          )
  end

  private

  def find_html
    html = File.read(Rails.root.join('app', 'views', action, view.to_s + '.html.erb'))
    html = ERB.new(html).result(binding)
    html
  end
end