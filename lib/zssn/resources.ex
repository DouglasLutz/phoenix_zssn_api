defmodule Zssn.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Zssn.Repo

  alias Zssn.Resources.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  alias Zssn.Resources.Survivor

  @doc """
  Returns the list of survivors.

  ## Examples

      iex> list_survivors()
      [%Survivor{}, ...]

  """
  def list_survivors do
    Repo.all(Survivor)
  end

  @doc """
  Gets a single survivor.

  Raises `Ecto.NoResultsError` if the Survivor does not exist.

  ## Examples

      iex> get_survivor!(123)
      %Survivor{}

      iex> get_survivor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survivor!(id), do: Repo.get!(Survivor, id)

  @doc """
  Creates a survivor.

  ## Examples

      iex> create_survivor(%{field: value})
      {:ok, %Survivor{}}

      iex> create_survivor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survivor(attrs \\ %{}) do
    %Survivor{}
    |> Survivor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survivor.

  ## Examples

      iex> update_survivor(survivor, %{field: new_value})
      {:ok, %Survivor{}}

      iex> update_survivor(survivor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survivor(%Survivor{} = survivor, attrs) do
    survivor
    |> Survivor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survivor.

  ## Examples

      iex> delete_survivor(survivor)
      {:ok, %Survivor{}}

      iex> delete_survivor(survivor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survivor(%Survivor{} = survivor) do
    Repo.delete(survivor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survivor changes.

  ## Examples

      iex> change_survivor(survivor)
      %Ecto.Changeset{data: %Survivor{}}

  """
  def change_survivor(%Survivor{} = survivor, attrs \\ %{}) do
    Survivor.changeset(survivor, attrs)
  end

  alias Zssn.Resources.SurvivorItem

  @doc """
  Returns the list of survivor_items.

  ## Examples

      iex> list_survivor_items()
      [%SurvivorItem{}, ...]

  """
  def list_survivor_items do
    Repo.all(SurvivorItem)
  end

  @doc """
  Gets a single survivor_item.

  Raises `Ecto.NoResultsError` if the Survivor item does not exist.

  ## Examples

      iex> get_survivor_item!(123)
      %SurvivorItem{}

      iex> get_survivor_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survivor_item!(id), do: Repo.get!(SurvivorItem, id)

  @doc """
  Creates a survivor_item.

  ## Examples

      iex> create_survivor_item(%{field: value})
      {:ok, %SurvivorItem{}}

      iex> create_survivor_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survivor_item(attrs \\ %{}) do
    %SurvivorItem{}
    |> SurvivorItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survivor_item.

  ## Examples

      iex> update_survivor_item(survivor_item, %{field: new_value})
      {:ok, %SurvivorItem{}}

      iex> update_survivor_item(survivor_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survivor_item(%SurvivorItem{} = survivor_item, attrs) do
    survivor_item
    |> SurvivorItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survivor_item.

  ## Examples

      iex> delete_survivor_item(survivor_item)
      {:ok, %SurvivorItem{}}

      iex> delete_survivor_item(survivor_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survivor_item(%SurvivorItem{} = survivor_item) do
    Repo.delete(survivor_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survivor_item changes.

  ## Examples

      iex> change_survivor_item(survivor_item)
      %Ecto.Changeset{data: %SurvivorItem{}}

  """
  def change_survivor_item(%SurvivorItem{} = survivor_item, attrs \\ %{}) do
    SurvivorItem.changeset(survivor_item, attrs)
  end
end
