defmodule ZssnWeb.Schema do
  use Absinthe.Schema

  alias ZssnWeb.Resolvers

  import_types __MODULE__.SurvivorTypes

  query do
    @desc "The list of survivors in the application"
    field :survivors, list_of(:survivor) do
      arg :filter, :survivor_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Resources.survivors/3
    end

  end

  @desc "Date data structure\nAccepts strings formated as \"YYYY-DD-MM\""
  scalar :date do
    parse fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
      {:ok, date} <- NaiveDateTime.from_iso8601(value <> " 00:00:00") do
        {:ok, date}
      else
        _ -> :error
      end
    end

    serialize fn date ->
      Date.to_iso8601(date)
    end
  end

  enum :sort_order do
    value :asc
    value :desc
  end
end
