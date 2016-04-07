defmodule MixTestWatch.Environment do
  @moduledoc """
  Responsible for Environment-specific behavior/syntax
  """

  if match? {:win32, _}, :os.type do

    @spec shell_launch(String.t) :: String.t

    @doc """
    Builds shell launch command
    """
    def shell_launch(cmd), do: ~s(cmd /c "#{cmd}")

    @spec escaped_quote(String.t) :: String.t

    @doc """
    Wraps string around escaped quotes in the shell
    """
    def escaped_quote(content), do: "^\"#{content}^\""

    @spec set_var(String.t, String.t) :: String.t

    @doc """
    Builds environment variable set command for the shell
    """
    def set_var(name, val, chained \\ false) do
      cmd = "set \"#{name}=#{val}\""
      if chained == :chained, do: cmd <> " &&", else: cmd
    end
  else

    @spec shell_launch(String.t) :: String.t

    @doc """
    Builds shell launch command
    """
    def shell_launch(cmd), do: ~s(sh -c "#{cmd}")

    @spec escaped_quote(String.t) :: String.t

    @doc """
    Wraps string around escaped quotes in the shell
    """
    def escaped_quote(content), do: "'#{content}'"

    @spec set_var(String.t, String.t) :: String.t

    @doc """
    Builds environment variable set command for the shell
    """
    def set_var(name, val, _), do: "#{name}=#{val}"
  end
end
