class Error < Response::Base
  def success?
    false
  end

  def on_error(&block)
    block.call(@data, @message, @status)
    self
  end

  def on_success(&block)
    self
  end

end
