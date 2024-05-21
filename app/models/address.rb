class Address
  def initialize(pref:)
    @pref = pref
  end

  def pref
    @pref.presence
  end

  def to_s
    @pref
  end
end
