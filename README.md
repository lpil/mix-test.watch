mix test.watch
==============

[![Hex version](https://img.shields.io/hexpm/v/mix_test_watch.svg "Hex version")](https://hex.pm/packages/mix_test_watch)
![Hex downloads](https://img.shields.io/hexpm/dt/mix_test_watch.svg "Hex downloads")

Automatically run your Elixir project's tests each time you save a file.

## Usage

Add it to your dependencies

```elixir
# mix.exs
def deps do
  [{:mix_test_watch, "~> 0.0.2"}]
end
```

Run the mix task

```
$ mix test.watch
```

Start hacking :)
