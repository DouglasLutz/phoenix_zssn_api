defmodule ZssnWeb.Schema do
  use Absinthe.Schema

  import_types __MODULE__.{SurvivorTypes, ItemTypes, InventoryTypes}

  query do
    import_fields :survivor_queries
    import_fields :item_queries
    import_fields :inventory_queries
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
