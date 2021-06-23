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
    ouput(index, "b")
    result_2 = _set_pos(@white)
    ouput(index, "w")
    routine(result_1 || result_2, index + 1)
  end

  defp _get_next_pos(value) do
    Reversi.Board.get_states() 
    |> Map.keys 
    |> Enum.filter(&Reversi.Board.can_set?(value, &1))
    |> Enum.max_by(
        &_prediction(Reversi.Board.get_states(), value, &1),
        fn -> nil end
      )
  end

  defp _prediction(states, value, pos) do
    Reversi.Board.set_value(states, value, pos) |> Reversi.Board.count
  end

  defp _set_pos(value), do: _get_next_pos(value) |> _set_pos(value)
  defp _set_pos(_pos=nil, _), do: false
  defp _set_pos(pos, value) do
    Reversi.Board.set_state(value, pos)
    true
  end

  defp ouput(index, value) do
    IO.inspect(Reversi.Board.get_states |> Reversi.Board.count)

    filename = "result/gen#{index}_#{value}.txt"
    File.write(filename, Reversi.Board.print_states())
  end
end
