defmodule MixTestWatch.FilesTest do
  use ExUnit.Case

  import MixTestWatch.Files, only: [find_test: 1]

  # The module in test actually checks whether files exist to find the right
  # one to run. We use ourselves as a fixture to avoid having to create a mock
  # file system, mock system methods or carry around a "fake" file system just
  # for tests.

  # We assume this test is run from the project's root directory
  @this_file Path.relative_to(__ENV__.file, System.cwd)

  test "test files are responsible for themselved" do
    assert @this_file == find_test(@this_file)
  end

  test "finds test file for implementation in lib/" do
    assert @this_file == find_test("lib/mix_test_watch/files.ex")
  end

  test "finds test file for implementation in web/ (for phoenix)" do
    assert @this_file == find_test("web/mix_test_watch/files.ex")
  end

  test "finds nothing when test file does not exist" do
    assert nil == find_test("lib/mix_test_watch/rummelpummel.ex")
  end

end
