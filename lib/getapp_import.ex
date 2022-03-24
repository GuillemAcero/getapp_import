defmodule GetappImport do
  @moduledoc """
  Documentation for `GetappImport`.
  """
  @accepted_providers ["capterra", "softwareadvice"]

  def main(args) do
    with {:ok, {provider, path}} <- validate_arguments(args),
         {:ok, result} <- read_file(provider, path) do
      IO.inspect("Final Result")
      IO.inspect(result)
      {:ok, result}
    else
      error -> error |> IO.inspect
    end
  end

  ### PRIV
  defp validate_arguments(args) do
    args
    |> validate_length()
    |> validate_provider()
    |> validate_path()
  end

  defp validate_length([provider, path]), do: {:ok, {provider, path}}
  defp validate_length(_), do: {:error, :invalid_number_of_arguments}

  defp validate_provider({:ok, {provider, file_path}}) when provider in @accepted_providers do
    {:ok, {String.to_atom(provider), file_path}}
  end

  defp validate_provider({:ok, _}), do: {:error, :invalid_provider}

  defp validate_provider({:error, _} = error), do: error

  defp validate_path({:ok, {provider, path}}) when is_binary(path) do
    if File.exists?(path) do
      {:ok, {provider, path}}
    else
      {:error, :file_not_found}
    end
  end

  defp validate_path({:ok, _}), do: {:error, :invalid_path_type}

  defp validate_path({:error, _} = error), do: error

  # Same as validate_arguments/1, could/should be private.
  defp read_file(:capterra, path) do
    if String.ends_with?(path, ".yaml") do
      [products] = YamlElixir.read_all_from_file!(path)

      try do
        {:ok, Enum.map(products, &format_yaml(&1))}
      rescue
        File.Error -> {:error, :file_bad_structure}
      end
    else
      {:error, :file_bad_extension}
    end
  end

  defp read_file(:softwareadvice, path) do
    if String.ends_with?(path, ".json") do
      data =
        path
        |> File.read!()
        |> Jason.decode!()

      try do
        {:ok, Enum.map(Map.get(data, "products"), &format_json(&1))}
      rescue
        File.Error -> {:error, :file_bad_structure}
      end
    else
      {:error, :file_bad_extension}
    end
  end

  # As I dont have mote context, let's asume that this 3 fields ARE required
  defp format_yaml(%{
         "name" => name,
         "tags" => tag,
         "twitter" => twitter
       }) do
    %{
      name: name,
      categories: tag,
      twitter: "@" <> twitter
    }
  end

  defp format_yaml(_), do: raise(File.Error)

  # In that case one product have twitter key missing, lets asume twitter is optional but the other
  # two keys are required
  defp format_json(
         %{
           "title" => name,
           "categories" => categories
         } = product
       ) do
    %{
      name: name,
      categories: categories,
      twitter: format_twitter_name(Map.get(product, "twitter", nil))
    }
  end

  defp format_json(_), do: raise(File.Error)

  defp format_twitter_name(nil), do: nil

  defp format_twitter_name(name), do: "@" <> name
end
