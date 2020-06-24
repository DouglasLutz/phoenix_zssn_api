defmodule ZssnWeb.ItemController do
  use ZssnWeb, :controller

  alias Zssn.Resources
  alias Zssn.Resources.Item

  action_fallback ZssnWeb.FallbackController

  def index(conn, _params) do
    items = Resources.list_items()
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"item" => item_params}) do
    with {:ok, %Item{} = item} <- Resources.create_item(item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.item_path(conn, :show, item))
      |> render("show.json", item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Resources.get_item!(id)
    render(conn, "show.json", item: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Resources.get_item!(id)

    with {:ok, %Item{} = item} <- Resources.update_item(item, item_params) do
      render(conn, "show.json", item: item)
    end
  end
end
