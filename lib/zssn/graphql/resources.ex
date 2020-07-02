defmodule Zssn.Graphql.Resources do
  import Ecto.Query, warn: false

  alias Zssn.Repo
  alias Zssn.Resources.Survivor

  def list_survivors(filters) do
    filters
    |> Enum.reduce(Survivor, fn
      {_, nil}, query ->
        query
      {:order, order}, query ->
        query |> order_by({^order, :name})
      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> Repo.all()
  end

  defp filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:name, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")
      {:gender, gender}, query ->
        from q in query, where: ilike(q.gender, ^gender)
      {:infected, infected}, query ->
        from q in query, where: q.infected == ^infected
      {:aged_above, age}, query ->
        from q in query, where: q.age >= ^age
      {:aged_below, age}, query ->
        from q in query, where: q.age <= ^age
    end)
  end
end
