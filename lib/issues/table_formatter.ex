defmodule Issues.TableFormatter do
  def display(list_of_issues) do
    column_widths = Enum.map ~w{number created_at title},
      fn key -> column_width(list_of_issues, key) end
    print_header(column_widths)
    list_of_issues
      |> Enum.each(fn issue -> print_row(issue, column_widths) end)
  end

  defp column_width(list_of_maps, key) do
    list_of_maps
      |> Enum.map(fn map -> field_width(map[key]) end)
      |> Enum.max
  end

  defp field_width(string) when is_binary(string), do: String.length(string)
  defp field_width(int) when is_integer(int), do: length(Integer.digits(int))
  defp field_width(nil), do: 0

  defp print_header([number_width, created_at_width, title_width]) do
    :io.format "~-#{number_width}s | ~-#{created_at_width}s | ~-#{title_width}s~n",
      ~w{# created_at title}
    :io.format "~#{number_width + 1}c+~#{created_at_width + 2}c+~#{title_width + 1}c~n",
      '---'
  end

  defp print_row(issue, [number_width, created_at_width, title_width]) do
    :io.format "~-#{number_width}b | ~-#{created_at_width}s | ~-#{title_width}s~n",
      [issue["number"], issue["created_at"], issue["title"]]
  end
end
