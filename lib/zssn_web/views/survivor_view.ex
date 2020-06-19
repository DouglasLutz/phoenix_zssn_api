defmodule ZssnWeb.SurvivorView do
  use ZssnWeb, :view
  alias ZssnWeb.SurvivorView

  def render("index.json", %{survivors: survivors}) do
    %{data: render_many(survivors, SurvivorView, "survivor.json")}
  end

  def render("show.json", %{survivor: survivor}) do
    %{data: render_one(survivor, SurvivorView, "survivor.json")}
  end

  def render("survivor.json", %{survivor: survivor}) do
    %{id: survivor.id,
      name: survivor.name,
      gender: survivor.gender,
      age: survivor.age,
      latitude: survivor.latitude,
      longitude: survivor.longitude}
  end
end
