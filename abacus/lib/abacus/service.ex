defmodule Abacus.Service do
  alias Abacus.Counter



  def start(raw_state) do
    initial_state =
      raw_state
      |> Counter.new()

    spawn(fn -> loop(initial_state) end)
  end

  def loop(count) do
    count
    |> listen
    |> loop
  end

  def listen(count) do
    receive do
      :inc ->
        Counter.add(count, 1)
      {:state, from} ->
        send(from, Counter.render(count))
        count
    end
  end

end
