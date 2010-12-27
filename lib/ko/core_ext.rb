class Exception

  #
  def self.raised?(&block)
    begin
      block.call
      false
    rescue self
      true
    rescue
      false
    end
  end

end
