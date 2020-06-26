defmodule ZssnWeb.SurvivorItemView do
  use ZssnWeb, :view

  def render("survivor_item.json", %{survivor_item: survivor_item}) do
    %{item_id: survivor_item.item_id,
      survivor_id: survivor_item.survivor_id,
      quantity: survivor_item.quantity}
  end

  def render("error.json", %{message: message}) do
    %{message: message}
  end

  def render("error.json", _) do
    %{message: "Trade not completed"}
  end

end
