defmodule MixTestWatch.ConfigTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  alias MixTestWatch.Config

  test "new/1 takes :tasks from the env" do
    TemporaryEnv.put :mix_test_watch, :tasks, :env_tasks do
      config = Config.new()
      assert config.tasks == :env_tasks
    end
  end

  test ~s(new/1 defaults :tasks to ["test"]) do
    TemporaryEnv.delete :mix_test_watch, :tasks do
      config = Config.new()
      assert config.tasks == ["test"]
    end
  end

  test "new/1 takes :exclude from the env" do
    TemporaryEnv.put :mix_test_watch, :exclude, [~r/migration_.*/] do
      config = Config.new()
      assert config.exclude == [~r/migration_.*/]
    end
  end

  test ":exclude contains common editor temp/swap files by default" do
    config = Config.new()
    # Emacs lock symlink
    assert ~r/\.#/ in config.exclude
  end

  test ":exclude contains default Phoenix migrations directory by default" do
    config = Config.new()
    assert ~r{priv/repo/migrations} in config.exclude
  end

  test "new/1 takes :extra_extensions from the env" do
    TemporaryEnv.put :mix_test_watch, :extra_extensions, [".haml"] do
      config = Config.new()
      assert config.extra_extensions == [".haml"]
    end
  end

  test "new/1 passes cli_args" do
    config = Config.new(["hello", "world"])
    assert config.cli_args == ["hello", "world"]
  end

  test "new/1 default cli_args to empty list" do
    config = Config.new()
    assert config.cli_args == []
  end

  test "new/1 default mix_env to test" do
    config = Config.new()
    assert config.mix_env == :test
  end

  test "new/1 takes :clear from the env" do
    TemporaryEnv.put :mix_test_watch, :clear, true do
      config = Config.new()
      assert config.clear
    end
  end

  test "new/1 takes :timestamp from the env" do
    TemporaryEnv.put :mix_test_watch, :timestamp, true do
      config = Config.new()
      assert config.timestamp
    end
  end

  test "new/1 takes :shell_prefix from the env" do
    TemporaryEnv.put :mix_test_watch, :cli_executable, "iex -S" do
      config = Config.new()
      assert config.cli_executable == "iex -S"
    end
  end
end
