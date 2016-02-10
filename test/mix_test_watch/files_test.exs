defmodule MixTestWatch.FilesTest do
  use ExUnit.Case
  import MixTestWatch.MockFsHelper

  import MixTestWatch.Files, only: [find_test: 1]

  test "test files are responsible for themselved" do
    tfile = "test/foo/bar_test.exs"
    with_mock_fs [tfile] do
      assert fs(tfile) == find_test(fs tfile)
    end
  end

  test "finds test file for implementation in lib/" do
    tfile = "test/bar/foo_test.exs"
    with_mock_fs [tfile] do
      assert fs(tfile) == find_test(fs "lib/bar/foo.ex")
    end
  end

  test "finds test file for implementation in web/ (for phoenix)" do
    tfile = "test/models/plant_test.exs"
    with_mock_fs [tfile] do
      assert fs(tfile) == find_test(fs "web/models/plant.ex")
    end
  end

  test "finds nothing when test file does not exist" do
    with_mock_fs [] do
      assert nil == find_test(fs "lib/bar/foo.ex")
    end
  end

end
