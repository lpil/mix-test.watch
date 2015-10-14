defmodule MixTestWatch.Command do
  @moduledoc """
  Responsible for forming our shell commands.
  """

  @spec build(String.t) :: String.t

  @doc """
  Builds the shell command that runs the desired mix task(s).
  """
  def build(args \\ "") do
    ~s(sh -c "MIX_ENV=test mix do run -e '#{ansi}', test #{args}")
  end


  @spec exec(String.t) :: :ok

  @doc """
  Runs a given shell command, steaming the output to STDOUT
  """
  def exec(exe) do
    args = ~w(stream binary exit_status use_stdio stderr_to_stdout)a
    {:spawn, exe} |> Port.open(args) |> results_loop
    :ok
  end


  @spec results_loop(port) :: pos_integer
  defp results_loop(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        results_loop(port)

      {^port, {:exit_status, status}} ->
        status
    end
  end


  @spec ansi :: String.t
  defp ansi do
    "Application.put_env(:elixir, :ansi_enabled, true);"
  end
end
