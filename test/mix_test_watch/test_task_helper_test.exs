defmodule TestTaskHelperTest do
  use ExUnit.Case, async: false
  alias MixTestWatch.TestTaskTest

  @doc """
  This test case is not intended to be run directly,
  but instead is used by MixTestWatch.TestTaskTest to
  assert that MixTestWatch.TestTask can be used to run
  the "test" mix task multiple times.

  Basically it's giving us a way to increment some
  mutable state each time this test is run. We can then
  make assertions about this number later.
  """
  test "increment state" do
    if Process.whereis(TestTaskTest) do
      Agent.update(TestTaskTest, fn x -> x + 1 end)
    end
  end
end
