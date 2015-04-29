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
  [{:mix_test_watch, "~> 0.1.0"}]
end
```

Run the mix task

```
$ mix test.watch
```

Start hacking :)

## Notes

On Linux you may need to install `inotify-tools`.

## Licence

```
mix test.watch
Copyright © 2015 Louis Pilfold

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
