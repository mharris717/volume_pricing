module FromHash
  def from_hash(ops)
    ops.each do |k,v|
      send("#{k}=",v)
    end
    self
  end
  def initialize(ops={})
    from_hash(ops)
  end
end

module Enumerable
  def sum
    inject { |s,i| s + i }
  end
end