defmodule Zssn.Survivors do
  import Ecto.Query, warn: false

  alias Zssn.Repo
  alias Zssn.Survivors.Survivor

  @spec list_survivors() :: [%Survivor{}]
  def list_survivors do
    Repo.all(Survivor)
    |> Repo.preload(:survivor_items)
  end

  @spec get_survivor!(integer() | binary()) :: %Survivor{}
  def get_survivor!(id) do
    Survivor
    |> Repo.get!(id)
    |> Repo.preload(:survivor_items)
  end

  @spec get_survivor(integer() | binary()) :: %Survivor{} | nil
  def get_survivor(id) do
    Survivor
    |> Repo.get(id)
    |> Repo.preload(:survivor_items)
  end

  @spec create_survivor(%{optional(atom | binary) => binary | number() | list(map()) | boolean()}) :: {:ok, %Survivor{}} | {:error, Ecto.Changeset}
  def create_survivor(attrs \\ %{}) do
    %Survivor{}
    |> Survivor.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_survivor(%Survivor{}, %{optional(atom | binary) => boolean() | number()}) :: {:ok, %Survivor{}} | {:error, Ecto.Changeset}
  def update_survivor(%Survivor{} = survivor, attrs) do
    survivor
    |> Survivor.changeset(attrs)
    |> Repo.update()
  end
end
