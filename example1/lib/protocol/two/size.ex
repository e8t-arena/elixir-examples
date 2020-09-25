defprotocol Protocol.Two.Size do
  def size(data)
end

defimpl Protocol.Two.Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Protocol.Two.Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Protocol.Two.Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end
