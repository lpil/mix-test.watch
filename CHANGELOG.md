Changelog
=========

## Unreleased (Blocked)

- The existing VM can now reused for running the tests with the HotRunner.
  This gives us Windows support and a performance increase.
  Sadly it is not production ready yet due to a bug in the Elixir compiler.

## Unreleased (To Release)

- Test runs optionally print a timestamp (Scotty @unclesnottie)
- Paths can be ignored by watcher (Alex Myasoedov @msoedov)
- Paths can be ignored by watcher (Alex Myasoedov @msoedov)
- Ability to specify additional watched file extensions. (Dave Shah @daveshah)
- Erlang `.hrl` header files are now watched.

## v0.2.6 - 2016.02.28

- The terminal can now be cleared between test runs.
  (Gerard de Brieder @smeevil)

## v0.2.5 - 2015.12.31

- It is now possible to run addition tasks using mix config.
- Erlang `.xrl` and `.yrl` files are watched. (John Hamelink @johnhamelink)
- The shell command used to run the tasks can be specified (i.e. `iex -S`).
  (John Hamelink @johnhamelink)
- Command line arguments are forwarded to tasks being run. (Johan Lind @behe)

## v0.2.3 - 2015.08.23

- The `_build` directory is ignored, as well as `deps/`.
- Erlang `.erl` files are now watched.

## v0.2.2 - 2015.08.22

- Tests now run once immediately after running the mix task. (Johan Lind @behe)
- Porcelain dependancy removed.
- Switched from bash to sh for running shell commands.
