defmodule MixTestWatch.Mixfile do
  use Mix.Project

  @source_url "https://github.com/lpil/mix-test.watch"
  @version "1.1.0"

  def project do
    [
      app: :mix_test_watch,
      version: @version,
      elixir: "~> 1.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      name: "mix test.watch",
      xref: [exclude: [IEx]],
      description: "Automatically run tests when files change",
      package: [
        maintainers: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{
          "Changelog" => "https://hexdocs.pm/mix_test_watch/changelog.html",
          "GitHub" => @source_url
        },
        files: ~w(LICENCE README.md CHANGELOG.md lib priv mix.exs)
      ]
    ]
  end

  def application do
    [
      mod: {MixTestWatch, []},
      applications: [:file_system]
    ]
  end

  defp deps do
    [
      # File system event watcher
      {:file_system, "~> 0.2.1 or ~> 0.3"},
      # App env state test helper
      {:temporary_env, "~> 2.0", only: :test},
      # Documentation generator
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end
end
