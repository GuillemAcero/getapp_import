defmodule GetappImport do
  @moduledoc """
  Documentation for `GetappImport`.
  """
  @accepted_providers ["capterra", "softwareadvice"]

  def main(args) do
    case validate_arguments(args) do
      {:error, _} = error ->
        error

      {:ok, {provider, path}} ->
        read_file(provider, path)
    end
  end

  def validate_arguments(args) do
    args
    |> validate_length()
    |> validate_provider()
    |> validate_path()
  end

  def read_file(:capterra, path) do
    [products] = YamlElixir.read_all_from_file!(path)

    try do
      Enum.map(products, &format_yaml(&1)) |> IO.inspect()
    rescue
      File.Error -> {:error, :file_bad_structure} |> IO.inspect()
    end
  end

  def read_file(:softwareadvice, path) do
  end

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

  ### PRIV

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
end
