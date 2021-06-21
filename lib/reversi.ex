defmodule Reversi do
  @moduledoc """
  Documentation for `Reversi`.
  """

  def hoge do
    Reversi.Board.start_link

    routine(true, 1)
  end

  @black 1
  @white -1
  def routine(false, _), do: nil
  def routine(true, index) do
    result_1 = _set_pos(@black) 
    File.write("result/gen#{index}_b.txt", Reversi.Board.print_states())
    result_2 = _set_pos(@white)
    File.write("result/gen#{index}_w.txt", Reversi.Board.print_states())
    routine(result_1 || result_2, index + 1)
  end

  defp _get_next_pos(value) do
    Reversi.Board.get_states() |> Map.keys |> Enum.find(fn pos -> Reversi.Board.can_set?(value, pos) end)
  end

  defp _set_pos(value), do: _get_next_pos(value) |> _set_pos(value)
  defp _set_pos(_pos=nil, _), do: false
  defp _set_pos(pos, value) do
    Reversi.Board.set_state(value, pos)
    true
  end
end
