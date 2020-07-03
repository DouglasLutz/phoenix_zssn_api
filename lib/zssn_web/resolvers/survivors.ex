defmodule ZssnWeb.Resolvers.Survivors do
  alias Zssn.Graphql.Survivors
  alias Zssn.Survivors.Survivor

  def survivors(_, args, _) do
    {:ok, Survivors.list_survivors(args)}
  end

  def create_survivor(_, %{input: params}, _) do
    case Survivors.create_survivor(params) do
      {:ok, survivor} ->
        {:ok, %{survivor: survivor}}
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  def update_survivor(_, %{id: id, input: params}, _) do
    with  %Survivor{} = survivor <- Survivors.get_survivor(id),
          {:ok, %Survivor{} = survivor} <- Survivors.update_survivor(survivor, params) do
      {:ok, %{survivor: survivor}}
    else
      nil ->
        {:ok, %{errors: [%{key: :id, message: "Couldn't find survivor"}]}}
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} ->
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
