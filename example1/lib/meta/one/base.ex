defmodule Meta.One.Base do
  # @callback get(String.t | Integer.t) :: Schema.t
  # @callback insert(Map.t) :: {:ok, Schema.t} | {:error, Changeset.t}

  defmacro __using__(_opts) do
    quote do
      # @behaviour
      def get(id) do
        # IO.puts "#{__MODULE__} #{id}"
        IO.puts "Base #{id}"
      end
    end
  end
end
