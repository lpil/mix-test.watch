defmodule MixTestWatch.PathTest do
  use ExUnit.Case

  import MixTestWatch.Path, only: [watching?: 1]

  test ".ex files are watched" do
    assert watching? "foo.ex"
  end

  test ".exs files are watched" do
    assert watching? "foo.exs"
  end

  test ".eex files are watched" do
    assert watching? "foo.eex"
  end

  test ".erl files are watched" do
    assert watching? "foo.erl"
  end

  test "misc files are not watched" do
    refute watching? "foo.rb"
    refute watching? "foo.js"
    refute watching? "foo.css"
    refute watching? "foo.lock"
    refute watching? "foo.html"
    refute watching? "foo.yaml"
    refute watching? "foo.json"
  end

  test "_build directory is not watched" do
    refute watching? "_build/dev/lib/mix_test_watch/ebin/mix_test_watch.ex"
    refute watching? "_build/dev/lib/mix_test_watch/ebin/mix_test_watch.exs"
    refute watching? "_build/dev/lib/mix_test_watch/ebin/mix_test_watch.eex"
  end

  test "deps directory is not watched" do
    refute watching? "deps/dogma/lib/dogma.ex"
    refute watching? "deps/dogma/lib/dogma.exs"
    refute watching? "deps/dogma/lib/dogma.eex"
  end
end
