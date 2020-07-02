defmodule Zssn.Items do
  import Ecto.Query, warn: false

  alias Zssn.Repo
  alias Zssn.Items.Item

  @spec list_items() :: [%Item{}]
  def list_items do
    Repo.all(Item)
  end

  @spec get_item!(integer() | binary()) :: %Item{}
  def get_item!(id), do: Repo.get!(Item, id)

  @spec create_item(%{optional(atom | binary) => binary | number()}) :: {:ok, %Item{}} | {:error, Ecto.Changeset}
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_item(%Item{}, %{optional(atom | binary) => binary | number()}) :: {:ok, %Item{}} | {:error, Ecto.Changeset}
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end
end
