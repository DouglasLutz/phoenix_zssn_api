defmodule Zssn.Graphql.Items do
  import Ecto.Query, warn: false

  alias Zssn.Repo
  def list(module, filters) do
    filters
    |> Enum.reduce(module, fn
      {_, nil}, query ->
        query
      {:order, order}, query ->
        query |> order_by({^order, :name})
      {:filter, filter}, query ->
        query |> filter_with(filter)
    end) |> Repo.all()
  end

  defp filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:name, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")
      {:valued_above, value}, query ->
        from q in query, where: q.value >= ^value
      {:valued_below, value}, query ->
        from q in query, where: q.value <= ^value
    end)
  end
end
