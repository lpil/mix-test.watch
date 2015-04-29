defmodule Mix.Tasks.Test.WatchTest do
  use ExUnit.Case
  use ShouldI

  should "run tests 1" do
    "but I'm not sure how to test this..."
  end

  should "run tests 2" do
    :timer.sleep 100
    "but I'm not sure how to test this..."
  end

  should "run tests 3" do
    :timer.sleep 200
    "but I'm not sure how to test this..."
  end

  should "run tests 4" do
    :timer.sleep 300
    "but I'm not sure how to test this..."
  end
end
