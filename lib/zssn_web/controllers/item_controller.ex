defmodule ZssnWeb.ItemController do
  use ZssnWeb, :controller

  alias Zssn.Items
  alias Zssn.Items.Item

  action_fallback ZssnWeb.FallbackController

  def index(conn, _params) do
    items = Items.list_items()
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"item" => item_params}) do
    with {:ok, %Item{} = item} <- Items.create_item(item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.item_path(conn, :show, item))
      |> render("show.json", item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Items.get_item!(id)
    render(conn, "show.json", item: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Items.get_item!(id)

    with {:ok, %Item{} = item} <- Items.update_item(item, item_params) do
      render(conn, "show.json", item: item)
    end
  end
end
