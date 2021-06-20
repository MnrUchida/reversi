defmodule Reversi.Board do
  @name __MODULE__

  @doc """
  Inital board.
  """
  def start_link do
    Agent.start_link(fn -> initial_board() end, name: @name)
  end

  def get_state(x, y),
  do: get_states()[{x, y}]

  def get_states,
  do: Agent.get(@name, &(&1))

  def set_state(value, pos) do
    Agent.update(@name, &set_value(&1, value, pos))
  end

  def can_set?(value, {x, y}) do
    _can_set?(value, {x, y}, Reversi.Board.get_state(x, y))
  end

  def get_all_lines(value, pos) do
    _get_all_lines(value, pos)
  end

  def set_value(states, value, pos) do
    Enum.reduce([pos | _get_all_lines(value, pos)], states, fn set_pos, acc -> 
      Map.put(acc, set_pos, value)
    end)
  end

  def print_states do
    key_fnc = fn {{_x, y}, _value} -> y end
    value_fnc = fn {{_x, _y}, value} -> value end

    get_states()
    |> Map.to_list()
    |> List.keysort(0)
    |> Enum.group_by(key_fnc, value_fnc)
    |> Enum.map(fn {_, values} -> Enum.join(values) end)
    |> Enum.join("\n")
    |> String.replace("-1", "w")
    |> String.replace("1", "b")
  end

  @range 1..8
  defp initial_board do
    line_fnc = fn x -> Enum.map(@range, &({{x, &1}, 0})) end
    Enum.map(@range, &(line_fnc.(&1))) 
    |> Enum.concat()
    |> Map.new()
    |> Map.merge(%{ {4,4} => -1, {4,5} => 1, {5,4} => 1, {5,5} => -1 })
  end

  defp _can_set?(value, pos, _cur_value = 0) do
    _get_all_lines(value, pos) |> Enum.empty?() == false
  end
  defp _can_set?(_value, _pos, _cur_value), do: false

  defp _get_all_lines(value, {x, y}) do
    Enum.flat_map(-1..1, fn x_inc ->
      Enum.flat_map(-1..1, fn y_inc ->
        next_value = Reversi.Board.get_state(x + x_inc, y + y_inc)
        _get_line(value, next_value, { x + x_inc, y + y_inc }, { x_inc, y_inc }, [])
      end)
    end) 
  end

  defp _get_line(_self_value, _value = nil, _pos, _inc, _acc), do: []
  defp _get_line(_self_value, _value = 0, _pos, _inc, _acc), do: []
  defp _get_line(self_value, self_value, _pos, _inc, acc), do: acc
  defp _get_line(self_value, _value, pos = {x, y}, inc = {x_inc, y_inc}, acc) do
    next_value = get_state(x + x_inc, y + y_inc)
    
    _get_line(self_value, next_value, {x + x_inc, y + y_inc}, inc, [pos | acc])
  end

end
