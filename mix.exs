defmodule Mix.Tasks.Test.Watch.Mixfile do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :mix_test_watch,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      name: "mix test.watch",
      description: "Automatically run tests on file change",
      package: [
        contributors: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/lpil/mix-test.watch"},
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
      {:fs, "~> 0.9.1"},
      {:porcelain, "~> 2.0.0"},
      {:shouldi, "~> 0.2.2", only: :test},
      {:mock, "~> 0.1.0", only: :test},
    ]
  end
end
