defmodule Reversi.Prediction do
  # def routine(cur_states, value) do
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
# Reversi.Board.get_states |> Reversi.Prediction._map_for_states(1, &Reversi.Board.count(&1)) |> Enum.max_by(fn({ _key, %{-1 => _, 1 => x}}) -> x end)


  def hoge do
    Reversi.Board.start_link
    Reversi.Board.get_states |> Reversi.Prediction._routine(1, 2, &Reversi.Board.count(&1))  
  end

  def _routine(cur_states, value, 0, fnc) do
    cur_states 
    |> _map_for_states(value, fn(states) -> _map_for_states(states, -value, &fnc.(&1)) end)
  end

  def _routine(cur_states, value, step, fnc) do
    IO.puts step
    routine_fnc = fn(states) -> 
                    _routine(states, value, step - 1, fnc)
                  end
    cur_states 
    |> _map_for_states(value, fn(states) -> 
                                _map_for_states(states, -value, routine_fnc) 
                              end)
  end


  def _map_for_states(cur_states, value, fnc) do
    _states(cur_states, value)
    |> Stream.map(fn { pos, states } -> Task.async(fn -> { pos, fnc.(states) } end) end)
    |> Enum.map(&Task.await/1)
  end

  def _states(states, value) do
    states
    |> Reversi.Board.can_set_positions(value)
    |> Enum.map(fn pos -> 
                  { pos, Reversi.Board.set_value(states, value, pos) }
                end)
  end
end
