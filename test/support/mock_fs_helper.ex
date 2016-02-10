defmodule MixTestWatch.MockFsHelper do
  @moduledoc """
  Sets up a temporary file system to be used in tests which need real files to
  exist. Paths in the given list will be touched before running the block and
  will be cleanup up afterwards.

    test "files exist when passed to macro" do
      file = "thefn0rd.txt"
      with_mock_fs [file] do
        assert File.exist?(fs file)
      end
    end

  Notices the usage of the `fs` macro to get the real path within the temporary
  file system.
  """

  @root "tmp/fs"
  import Path, only: [join: 2]

  defmacro with_mock_fs(files, test) do
    quote do
      try do
        if File.dir?(unquote(@root)) do # tabula rasa
          File.rm_rf(unquote(@root))
        end
        File.mkdir_p(unquote(@root))    # empty save space
        Enum.each unquote(files), fn (file)->
          if String.contains?(file, "..") do
            raise "no shenanigans with '..'" # keep bumblebees to a minimum
          end
          path = join(unquote(@root), file)
          :ok = File.mkdir_p( Path.dirname(path) )
          :ok = File.touch(path)
        end
        # Run all the tests inside the filesystem
        unquote(test)
      after
        File.rm_rf(unquote(@root))
      end
    end
  end

  defmacro fs(path) do
    quote do
      join(unquote(@root), unquote(path))
    end
  end
end
