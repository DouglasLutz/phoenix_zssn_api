defmodule ZssnWeb.Schema do
  use Absinthe.Schema

  import_types __MODULE__.{SurvivorTypes, ItemTypes, InventoryTypes}

  query do
    import_fields :survivor_queries
    import_fields :item_queries
    import_fields :inventory_queries
  end

  mutation do
    import_fields :survivor_mutations
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end

  @desc "Date data structure - Accepts strings formated as \"YYYY-DD-MM\""
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

  @desc "Decimal scalar type - Accepts strings with a number"
  scalar :decimal do
    parse fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input do
        Decimal.parse(value)
      else
        _ -> :error
      end
    end

    serialize &to_string/1
  end

  enum :sort_order do
    value :asc
    value :desc
  end
end
