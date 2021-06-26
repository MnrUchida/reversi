defmodule Reversi.Trial do
  @moduledoc """
  Documentation for `Reversi`.
  """

  def hoge2(value) do
    [Reversi.Board.get_states]
    |> Enum.flat_map(&_prediction_states(&1, value))
    |> Enum.flat_map(&_prediction_states(&1, -value))
  end

  def huga(value) do
    Reversi.Board.start_link

    Reversi.Board.get_states
    |> _prediction_states(value)
    |> Enum.flat_map(&_prediction_states(&1, -value))
    |> Enum.flat_map(&_prediction_states(&1, value))
    |> Enum.uniq
    |> Enum.with_index(fn element, index -> {index, element} end)
    |> Enum.map(fn { index, states } ->
                  IO.inspect Reversi.Board.count(states)
                  File.write("result/gen#{index}.txt", Reversi.Board.print_states(states))
                end)
  end

  def _prediction_states(states, value) do
    states
    |> Reversi.Board.can_set_positions(value)
    |> Enum.map(&Reversi.Board.set_value(states, value, &1))
  end
end
