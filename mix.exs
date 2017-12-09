defmodule MixTestWatch.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [app: :mix_test_watch,
     version: @version,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     name: "mix test.watch",
     description: "Automatically run tests when files change",
     package: [
       maintainers: ["Louis Pilfold"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/lpil/mix-test.watch"},
       files: ~w(LICENCE README.md lib mix.exs)]]
  end

  def application do
    [mod: {MixTestWatch, []}, applications: [:fs]]
  end

  defp deps do
    [# File system event watcher
     {:fs, "~> 2.12"},
     # Style linter
     {:dogma, "~> 0.1", only: ~w(dev test)a},
     # App env state test helper
     {:temporary_env, "~> 1.0", only: :test},
     # Documentation generator
     {:ex_doc, ">= 0.12.0", only: :dev}]
  end
end
