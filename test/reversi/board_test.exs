defmodule Reversi.BoardTest do
  use ExUnit.Case
  doctest Reversi.Board

  test "initial_board" do
    Reversi.Board.start_link()
    assert Reversi.Board.print_states() == String.trim("""
    00000000
    00000000
    00000000
    000wb000
    000bw000
    00000000
    00000000
    00000000
    """)
  end

  test "can_set?" do
    Reversi.Board.start_link()

    assert Reversi.Board.can_set?(-1, {3, 2}) == false
    assert Reversi.Board.can_set?(-1, {3, 3}) == false
    assert Reversi.Board.can_set?(-1, {3, 4}) == false
    assert Reversi.Board.can_set?(-1, {3, 5}) == true
    assert Reversi.Board.can_set?(-1, {3, 6}) == false

    assert Reversi.Board.can_set?(-1, {4, 2}) == false
    assert Reversi.Board.can_set?(-1, {4, 3}) == false
    assert Reversi.Board.can_set?(-1, {4, 4}) == false
    assert Reversi.Board.can_set?(-1, {4, 5}) == false
    assert Reversi.Board.can_set?(-1, {4, 6}) == true

    assert Reversi.Board.can_set?(-1, {5, 2}) == false
    assert Reversi.Board.can_set?(-1, {5, 3}) == true
    assert Reversi.Board.can_set?(-1, {5, 4}) == false
    assert Reversi.Board.can_set?(-1, {5, 5}) == false
    assert Reversi.Board.can_set?(-1, {5, 6}) == false

    assert Reversi.Board.can_set?(-1, {6, 2}) == false
    assert Reversi.Board.can_set?(-1, {6, 3}) == false
    assert Reversi.Board.can_set?(-1, {6, 4}) == true
    assert Reversi.Board.can_set?(-1, {6, 5}) == false
    assert Reversi.Board.can_set?(-1, {6, 6}) == false

    assert Reversi.Board.can_set?(1, {3, 2}) == false
    assert Reversi.Board.can_set?(1, {3, 3}) == false
    assert Reversi.Board.can_set?(1, {3, 4}) == true
    assert Reversi.Board.can_set?(1, {3, 5}) == false
    assert Reversi.Board.can_set?(1, {3, 6}) == false

    assert Reversi.Board.can_set?(1, {4, 2}) == false
    assert Reversi.Board.can_set?(1, {4, 3}) == true
    assert Reversi.Board.can_set?(1, {4, 4}) == false
    assert Reversi.Board.can_set?(1, {4, 5}) == false
    assert Reversi.Board.can_set?(1, {4, 6}) == false

    assert Reversi.Board.can_set?(1, {5, 2}) == false
    assert Reversi.Board.can_set?(1, {5, 3}) == false
    assert Reversi.Board.can_set?(1, {5, 4}) == false
    assert Reversi.Board.can_set?(1, {5, 5}) == false
    assert Reversi.Board.can_set?(1, {5, 6}) == true

    assert Reversi.Board.can_set?(1, {6, 2}) == false
    assert Reversi.Board.can_set?(1, {6, 3}) == false
    assert Reversi.Board.can_set?(1, {6, 4}) == false
    assert Reversi.Board.can_set?(1, {6, 5}) == true
    assert Reversi.Board.can_set?(1, {6, 6}) == false
  end

  test "set_state" do
    Reversi.Board.start_link()
    Reversi.Board.set_state({3,4}, 1)
    assert Reversi.Board.print_states() == String.trim("""
    00000000
    00000000
    00000000
    00bbb000
    000bw000
    00000000
    00000000
    00000000
    """)

    Reversi.Board.set_state({3,5}, -1)
    assert Reversi.Board.print_states() == String.trim("""
    00000000
    00000000
    00000000
    00bbb000
    00www000
    00000000
    00000000
    00000000
    """)

    Reversi.Board.set_state({3,6}, 1)
    assert Reversi.Board.print_states() == String.trim("""
    00000000
    00000000
    00000000
    00bbb000
    00bbw000
    00b00000
    00000000
    00000000
    """)
  end

end
