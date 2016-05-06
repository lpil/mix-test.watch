defmodule MixTestWatch.ConfigTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  alias MixTestWatch.Config

  test "new/1 takes :tasks from the env" do
    TemporaryEnv.set :mix_test_watch, tasks: :env_tasks do
      config = Config.new
      assert config.tasks == :env_tasks
    end
  end

  test ~s(new/1 defaults :tasks to ["test"]) do
    TemporaryEnv.delete :mix_test_watch, :tasks do
      config = Config.new
      assert config.tasks == ["test"]
    end
  end

  test "new/1 takes :exclude from the env" do
    TemporaryEnv.set :mix_test_watch, exclude: [~r/migration_.*/] do
      config = Config.new
      assert config.exclude == [~r/migration_.*/]
    end
  end

  test "new/1 passes cli_args" do
    config = Config.new(["hello", "world"])
    assert config.cli_args == ["hello", "world"]
  end

  test "new/1 default cli_args to empty list" do
    config = Config.new
    assert config.cli_args == []
  end

  test "new/1 takes :clear from the env" do
    TemporaryEnv.set :mix_test_watch, clear: true do
      config = Config.new
      assert config.clear
    end
  end

end
