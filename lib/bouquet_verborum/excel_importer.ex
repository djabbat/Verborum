defmodule BouquetVerborum.ExcelImporter do
  alias BouquetVerborum.Repo
  alias BouquetVerborum.Lexicon

  def import_excel(file_path) do
    # Parse the Excel file
    [ok: table_id] = Xlsxir.multi_extract(file_path)
    IO.inspect(table_id)

    case Xlsxir.multi_extract(file_path) do
      [ok: table_id] ->
        # Fetch all rows from the sheet
        rows = Xlsxir.get_list(table_id)

        # Skip the header row and insert each record
        rows
        # Skip the header row
        |> Enum.drop(1)
        |> Enum.each(fn row ->
          insert_row(row)
        end)

        # Close the Excel table
        Xlsxir.close(table_id)

      _ ->
        IO.puts("failed")
    end
  end

  def update_map_with_keys(map, keys, values) do
    keys
    # Pair each key with its index
    |> Enum.with_index()
    |> Enum.reduce(map, fn {key, index}, acc_map ->
      # Get the value at the current index, defaulting to nil if out of bounds
      value = Enum.at(values, index, nil)

      # Process the value based on the key
      processed_value =
        case {key, value} do
          # Ensure :meaning is always a string
          {:meaning, v} ->
            to_string(v)

          {:chapter, v} when v != nil ->
            case Integer.parse(v) do
              # Successfully parsed an integer
              {int, ""} -> int
              # Parsing failed, return default
              _ -> 0
            end

          # Convert floats to integers
          {_, v} when is_float(v) ->
            trunc(v)

          # Leave other values as is
          {_, v} ->
            v
        end

      # Update the map with the current key and processed value
      Map.put(acc_map, key, processed_value)
    end)
  end

  # def update_map_with_keys(map, keys, values, _test) do
  #   keys
  #   |> Enum.reduce({map, values}, fn key, {acc_map, remaining_values} ->
  #     # Get the head of the remaining values

  #     head =
  #       case get_head(remaining_values) do
  #         # Convert float to integer
  #         value when is_float(value) -> trunc(value)
  #         # Convert value to string if the key is :meaning
  #         value when key == :meaning -> to_string(value)
  #         # Leave other values as is
  #         value -> value
  #       end

  #     # Update the map with the current key and value (or nil)
  #     updated_map = Map.put(acc_map, key, head)

  #     # Return the updated map and the tail of the remaining values
  #     {updated_map, get_tail(remaining_values)}
  #   end)
  #   # Extract the final map
  #   |> elem(0)
  # end

  # # Function to get the head of a list or return nil for an empty list
  # defp get_head([]), do: nil
  # defp get_head([head | _]), do: head

  # # Function to get the tail of a list or return an empty list
  # defp get_tail([]), do: []
  # defp get_tail([_ | tail]), do: tail

  defp insert_row(data) do
    [_id | row] = data

    schema_keys = [
      :word,
      :meaning,
      :origin,
      :book,
      :chapter,
      :paragraph,
      :latitude,
      :longitude,
      :language
    ]

    record = %{}
    updated_map = update_map_with_keys(record, schema_keys, row)

    %Lexicon{}
    |> Lexicon.changeset(updated_map)
    |> Repo.insert()
  end
end
