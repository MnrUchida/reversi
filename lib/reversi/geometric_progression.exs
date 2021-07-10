defmodule Reversi.GeometricProgression do
  def start(step) do
    fnc = fn(task, {_, sum}) -> 
      { _, cur } = Task.await(task)
      sum + cur 
    end
    routine(0, step, fnc)
  end

  def routine(cur_idx, 0, fnc) do
    { cur_idx, fnc.(Task.async(fn -> { cur_idx, cur_idx } end), {0, 0}) }
  end

  def routine(cur_idx, step, fnc) do
    [1, 2, 3]
    |> Stream.map(fn index -> Task.async(fn -> routine(index, step - 1, fnc) end) end)
    |> Enum.reduce({0, 0}, fn(task, acc) -> { cur_idx, fnc.(task, acc) } end)
  end
end
