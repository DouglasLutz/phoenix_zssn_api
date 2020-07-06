defmodule ZssnWeb.Resolvers.Support.ErrorFormat do
  def transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn
        {key, [%{} = value]} ->
          %{key: "#{key}.#{value |> Map.keys |> List.first}",
            message: value |> Map.values |> List.first}
        {key, value} ->
          %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error) :: String.t
  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
