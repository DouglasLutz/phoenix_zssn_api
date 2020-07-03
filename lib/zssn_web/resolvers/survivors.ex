defmodule ZssnWeb.Resolvers.Survivors do
  alias Zssn.Graphql.Survivors

  def survivors(_, args, _) do
    {:ok, Survivors.list_survivors(args)}
  end

  def create_survivor(_, %{input: params}, _) do
    case Survivors.create_survivor(params) do
      {:ok, _} = success ->
        success
      {:error, changeset} ->
        {
          :error,
          message: "Could not create survivor",
          details: error_details(changeset)
        }
    end
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
