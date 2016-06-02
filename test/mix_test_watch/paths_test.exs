defmodule MixTestWatch.PathTest do
  use ExUnit.Case

  import MixTestWatch.Path, only: [watching?: 1, watching?: 2, excluded?: 2]

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

  test ".xrl files are watched" do
    assert watching? "foo.xrl"
  end

  test ".yrl files are watched" do
    assert watching? "foo.yrl"
  end

  test ".hrl files are watched" do
    assert watching? "foo.hrl"
  end

  test "extra extensions are watched" do
    extras = %{extra_extensions: [".ex", ".haml", ".foo", ".txt"] }
    assert watching? extras, "foo.ex"
    assert watching? extras, "index.html.haml"
    assert watching? extras, "my.foo"
    assert watching? extras, "best.txt"
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

  test "migrations_.* files should be excluded watched" do
    assert excluded? %{exclude: [~r/migrations_.*/]}, "migrations_files/foo.exs"
  end

  test "app.ex is not excluded by migrations_.* pattern" do
    refute excluded? %{exclude: [~r/migrations_.*/]}, "app.ex"
  end

end
