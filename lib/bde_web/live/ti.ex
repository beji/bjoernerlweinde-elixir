defmodule BdeWeb.TiLive do
  use Phoenix.LiveView

  @races [
           "Federation of Sol",
           "Sardakk N'Orr",
           "The Barony of Letnev",
           "The Emirates of Hacan",
           "The L1Z1X Mindnet",
           "The Mentak Coalition",
           "The Naalu Collective",
           "The Xxcha Kingdom",
           "The Yssaril Tribes",
           "Universities of Jol-Nar",
           "Clan of Saar",
           "Embers of Muaat",
           "The Winnu",
           "The Yin Brotherhood",
           "The Arborec",
           "The Ghosts of Creuss",
           "The Nekro Virus"
         ]
         |> Enum.sort()

  def render(assigns) do
    BdeWeb.PageView.render("ti.html", assigns)
  end

  def handle_event("ti-shuffle", formdata, %{assigns: %{races: races}} = socket) do
    names_only =
      formdata
      |> Enum.map(fn {_key, name} -> name end)

    names_without_empty =
      names_only
      |> Enum.filter(fn name -> name != "" end)

    names_and_races = assign_races_to_players(names_without_empty, races)

    {:noreply,
     assign(socket,
       names_and_races: names_and_races,
       players: names_only
     )}
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket, races: @races, names_and_races: [], players: 0..7 |> Enum.map(fn _ -> "" end))}
  end

  defp assign_races_to_players(players, races) do
    assign_races_to_players(players, races, [])
  end

  defp assign_races_to_players([], _races, acc)
       when is_list(acc) do
    acc
  end

  defp assign_races_to_players(players, races, acc)
       when is_list(players) and is_list(races) and is_list(acc) do
    [player | players_left] = players
    [race | races_left] = Enum.shuffle(races)
    acc = acc ++ [{player, race}]
    assign_races_to_players(players_left, races_left, acc)
  end
end
