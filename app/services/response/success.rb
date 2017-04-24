class Success < Response::Base
  def success?
    true
  end

  def on_success(&block)
    block.call(@data, @message, @status)
    self
  end

  def on_error(&block)
    self
  end

end