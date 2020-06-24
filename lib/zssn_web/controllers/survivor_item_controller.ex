defmodule ZssnWeb.SurvivorItemController do
  use ZssnWeb, :controller

  alias Zssn.Resources
  alias Zssn.Resources.SurvivorItem

  action_fallback ZssnWeb.FallbackController

  def update(conn, %{"id" => id, "survivor_item" => survivor_item_params}) do
    survivor_item = Resources.get_survivor_item!(id)

    with {:ok, %SurvivorItem{} = survivor_item} <- Resources.update_survivor_item(survivor_item, survivor_item_params) do
      render(conn, "show.json", survivor_item: survivor_item)
    end
  end
end
