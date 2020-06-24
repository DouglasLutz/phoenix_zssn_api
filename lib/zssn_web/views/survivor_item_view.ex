defmodule ZssnWeb.SurvivorItemView do
  use ZssnWeb, :view
  alias ZssnWeb.SurvivorItemView

  def render("index.json", %{survivor_items: survivor_items}) do
    %{data: render_many(survivor_items, SurvivorItemView, "survivor_item.json")}
  end

  def render("show.json", %{survivor_item: survivor_item}) do
    %{data: render_one(survivor_item, SurvivorItemView, "survivor_item.json")}
  end

  def render("survivor_item.json", %{survivor_item: survivor_item}) do
    %{item_id: survivor_item.item_id,
      survivor_id: survivor_item.survivor_id,
      quantity: survivor_item.quantity}
  end
end
