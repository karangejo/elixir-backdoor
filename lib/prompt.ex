defmodule Backdoor.Prompt do

  def remove_newline(line) do
    line
    |> String.replace("\r", "")
    |> String.replace("\n", "")
  end

  def add_prompt(charlist) do
    charlist ++ '\n\r =>>$'
  end

  def add_prompt_string(string) do
    string <> "\n\r =>>$"
  end

  def os_info do
    type =
      :os.type
      |> Tuple.to_list
      |> Enum.join(", ")
    version =
      :os.version
      |> Tuple.to_list
      |> Enum.join(".")
      type <> ", " <> version
  end

  def env_info do
    :os.getenv |> Enum.join("\n\r")
  end

end
