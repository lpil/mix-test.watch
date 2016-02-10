Changelog
=========

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
