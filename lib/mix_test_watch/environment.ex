defmodule MixTestWatch.Environment do
  if match? {:win32, _}, :os.type do
    def shell_launch(cmd), do: ~s(cmd /c "#{cmd}")
    
    def escaped_quote(content), do: "^\"#{content}^\""

    def set_var(name, val, chained \\ false) do 
      cmd = "set \"#{name}=#{val}\""
      if chained == :chained, do: cmd <> " &&", else: cmd
    end
  else
    def shell_launch(cmd), do: ~s(sh -c "#{cmd}")
    
    def escaped_quote(content), do: "'#{content}'"

    def set_var(name, val, _), do: "#{name}=#{val}"
  end
end