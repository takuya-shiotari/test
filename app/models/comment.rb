class Comment
  def initialize(body)
    @body = body
  end

  attr_reader :body

  # @param [Comment] other
  # @return [Boolean]
  def ==(other)
    other.body == body
  end

  def to_s
    @body
  end
end
