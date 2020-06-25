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
      |> render("create.json", survivor: survivor)
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

  def report(conn, %{"id" => id}) do
    survivor = Resources.get_survivor!(id)
    attrs = %{reports: (survivor.reports + 1),
              infected: (survivor.reports + 1 >= 3)}

    with {:ok, %Survivor{} = survivor} <- Resources.update_survivor(survivor, attrs) do
      render(conn, "show.json", survivor: survivor)
    end
  end
end
