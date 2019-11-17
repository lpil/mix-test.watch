Changelog
=========

## v1.0.2 - 2019-11-17

- Zombie killer script is run with bash to avoid platform specific issues with
  sh implementations.

## v1.0.1 - 2019-10-25

- Include zombie killer script in hex package.

## v1.0.0 - 2019-10-25

- LiveView templates are now watched.

## v0.9.0 - 2018-09-17

- Avoid starting application if `--no-start` is given.
- Hot runner removed.

## v0.8.0 - 2018-07-30

- Application started on test run. Revert of v0.7 behaviour.

## v0.7.0 - 2018-07-35

- No longer start application on test run.
- Do not watch the Ecto migration directory by default.

## v0.6.0 - 2018-03-27

- Switch from `fs` to `file_system` for file system event watching.

## v0.5.0 - 2017-08-26

- Windows support (Rustam @rustamtolipov)

## v0.4.1 - 2017-06-21

- Revert to `fs` v0.9.1 to maintain Phoenix Live Reload compatibility.
  https://github.com/phoenixframework/phoenix_live_reload/commit/e54bf6fb301436797ff589e0b76a047bb79b6870

## v0.4.0 - 2017-04-22

- Emacs temporary files can no longer trigger a test run.

## v0.3.3 - 2017-02-08

- Fixed a bug where arguments were not being correctly passed to the
  test running BEAM instance.

## v0.3.1 - 2017-02-04

- Fixed race condition bug on OSX where tests would fail to run when
  files are changed.

## v0.3.0 - 2017-01-29

- Test runs optionally print a timestamp (Scotty @unclesnottie)
- Paths can be ignored by watcher (Alex Myasoedov @msoedov)
- Paths can be ignored by watcher (Alex Myasoedov @msoedov)
- Ability to specify additional watched file extensions. (Dave Shah @daveshah)
- Erlang `.hrl` header files are now watched.
- The existing VM can now reused for running the tests with the HotRunner.
  This gives us Windows support and a performance increase.
  Sadly it cannot be used as the default due to a bug in the Elixir compiler.

## v0.2.6 - 2016-02-28

- The terminal can now be cleared between test runs.
  (Gerard de Brieder @smeevil)

## v0.2.5 - 2015-12-31

- It is now possible to run addition tasks using mix config.
- Erlang `.xrl` and `.yrl` files are watched. (John Hamelink @johnhamelink)
- The shell command used to run the tasks can be specified (i.e. `iex -S`).
  (John Hamelink @johnhamelink)
- Command line arguments are forwarded to tasks being run. (Johan Lind @behe)

## v0.2.3 - 2015-08-23

- The `_build` directory is ignored, as well as `deps/`.
- Erlang `.erl` files are now watched.

## v0.2.2 - 2015-08-22

- Tests now run once immediately after running the mix task. (Johan Lind @behe)
- Porcelain dependancy removed.
- Switched from bash to sh for running shell commands.
