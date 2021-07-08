defmodule Reversi.Trial do
  @moduledoc """
  Documentation for `Reversi`.
  """

  # def prediction_routine(cur_states, value) do
  #   _states(cur_states, value)
  #   |> Enum.map(fn { pos, states } -> 
  #                 { 
  #                   pos, 
  #                   _states(states, -value) 
  #                   |> Enum.map(fn {_, state} -> 
  #                                   max_count_pos(state, value) |> _count(state, value)
  #                     end)
  #                   |> Enum.max
  #                 }
  #               end )
  # end

  # def max_count_pos(states, value) do
  #   states
  #   |> Reversi.Board.can_set_positions(value)
  #   |> Enum.max_by(
  #       &_count(&1, states, value),
  #       fn -> nil end
  #     )
  # end

  def hoge(states, value) do
    prediction_routine(states, value)
  end

  def prediction_routine(cur_states, value) do
    _prediction_states(cur_states, value)
    |> Enum.map(fn { pos, states } -> 
                  { 
                    pos, 
                    _prediction_states(states, -value) 
                    |> Enum.map(fn {_, state} -> 
                                    max_count_pos(state, value) |> _prediction_count(state, value)
                      end)
                    |> Enum.max
                  }
                end )
  end

  def prediction_routine(states, value) do
    _prediction_states(states, value)
    |> Enum.flat_map(&_prediction_states(&1, -value))
  end

  def max_count_pos(states, value) do
    states
    |> Reversi.Board.can_set_positions(value)
    |> Enum.max_by(
        &_prediction_count(&1, states, value),
        fn -> nil end
      )
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
    |> Enum.map(fn pos -> 
                  { pos, Reversi.Board.set_value(states, value, pos) }
                end)
  end

  defp _prediction_count(pos, states, value) do
    Reversi.Board.set_value(states, value, pos) 
    |> Reversi.Board.count
  end
end
