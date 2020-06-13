# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Zssn.Repo.insert!(%Zssn.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Zssn.Repo
alias Zssn.Resources.Item

Repo.insert! %Item{name: "Water", value: 4}
Repo.insert! %Item{name: "Food", value: 3}
Repo.insert! %Item{name: "Medication", value: 2}
Repo.insert! %Item{name: "Ammunition", value: 1}
