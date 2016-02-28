defmodule Mix.Tasks.Test.Watch.Mixfile do
  use Mix.Project

  @version "0.2.6"

  def project do
    [
      app: :mix_test_watch,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      name: "mix test.watch",
      description: "Automatically run tests when files change",
      package: [
        maintainers: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/lpil/mix-test.watch"},
        files: ~w(LICENCE README.md lib mix.exs),
      ]
    ]
  end

  def application do
    [
      applications: []
    ]
  end

  defp deps do
    [
      # File system event watcher
      {:fs, "~> 0.9.1"},
      # Style linter
      {:dogma, "~> 0.1", only: ~w(dev test)a},
      # App env state test helper
      {:temporary_env, "~> 1.0", only: :test},
    ]
  end
end
