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
      longitude: survivor.longitude,
      infected: survivor.infected,
      reports: survivor.reports,
      survivor_items: render_many(survivor.survivor_items, ZssnWeb.SurvivorItemView, "survivor_item.json")
    }
  end

  def render("create.json", %{survivor: survivor}) do
    %{data: render_one(survivor, SurvivorView, "created_survivor.json")}
  end

  def render("created_survivor.json", %{survivor: survivor}) do
    %{id: survivor.id,
      name: survivor.name,
      gender: survivor.gender,
      age: survivor.age,
      latitude: survivor.latitude,
      longitude: survivor.longitude
    }
  end
end
