defmodule ZssnWeb.SurvivorController do
  use ZssnWeb, :controller

  alias Zssn.Resources
  alias Zssn.Resources.Survivor

  action_fallback ZssnWeb.FallbackController

  def index(conn, _params) do
    survivors = Resources.list_survivors()
    render(conn, "index.json", survivors: survivors)
  end

  def create(conn, %{"survivor" => survivor_params}) do
    with {:ok, %Survivor{} = survivor} <- Resources.create_survivor(survivor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.survivor_path(conn, :show, survivor))
      |> render("show.json", survivor: survivor)
    end
  end

  def show(conn, %{"id" => id}) do
    survivor = Resources.get_survivor!(id)
    render(conn, "show.json", survivor: survivor)
  end

  def update(conn, %{"id" => id, "survivor" => survivor_params}) do
    survivor = Resources.get_survivor!(id)

    with {:ok, %Survivor{} = survivor} <- Resources.update_survivor(survivor, survivor_params) do
      render(conn, "show.json", survivor: survivor)
    end
  end

  def delete(conn, %{"id" => id}) do
    survivor = Resources.get_survivor!(id)

    with {:ok, %Survivor{}} <- Resources.delete_survivor(survivor) do
      send_resp(conn, :no_content, "")
    end
  end
end
