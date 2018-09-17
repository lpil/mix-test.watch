defmodule MixTestWatch.Mixfile do
  use Mix.Project

  @version "0.9.0"

  def project do
    [
      app: :mix_test_watch,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "mix test.watch",
      description: "Automatically run tests when files change",
      package: [
        maintainers: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/lpil/mix-test.watch"},
        files: ~w(LICENCE README.md lib mix.exs)
      ]
    ]
  end

  def application do
    [mod: {MixTestWatch, []}, applications: [:file_system]]
  end

  defp deps do
    # File system event watcher
    [
      {:file_system, "~> 0.2.1 or ~> 0.3"},
      # App env state test helper
      {:temporary_env, "~> 2.0", only: :test},
      # Documentation generator
      {:ex_doc, ">= 0.12.0", only: :dev}
    ]
  end
end
