defmodule Mix.Tasks.Test.WatchTest do
  use ExUnit.Case

  delays = Enum.map( 0..14, fn n -> n * 2 end )

  for delay <- delays do
    test "A dot after #{delay} ms" do
      :timer.sleep unquote(delay)
      nil
    end
  end
end
