defmodule MixTestWatch.Shell do
  @moduledoc """
  Responsible for running of shell commands.
  """


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
end
