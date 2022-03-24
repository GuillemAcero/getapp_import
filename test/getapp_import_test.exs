defmodule GetappImportTest do
  use ExUnit.Case

  describe "validate_arguments/1" do
    test "returns ok when params are valid" do
      assert {:ok, _} = GetappImport.validate_arguments(["capterra", "priv/feed_products/capterra.yaml"])
    end

    test "returns error when number of arguments invalid" do
      assert {:error, :invalid_number_of_arguments} == GetappImport.validate_arguments("arg1")
      assert {:error, :invalid_number_of_arguments} == GetappImport.validate_arguments(["arg1", "arg2", "arg3"])
    end

    test "retruns error when the provider is invalid" do
      assert {:error, :invalid_provider} == GetappImport.validate_arguments(["invalid", "path"])
      assert {:error, :invalid_provider} == GetappImport.validate_arguments([:invalid, "path"])
      assert {:error, :invalid_provider} == GetappImport.validate_arguments([1234, "path"])
    end

    test "returns error if file path is invalid" do
      assert {:error, :invalid_path_type} == GetappImport.validate_arguments(["capterra", :not_a_path])
      assert {:error, :invalid_path_type} == GetappImport.validate_arguments(["capterra", 12345])
    end

    test "returns error if file does not exist" do
      assert {:error, :file_not_found} == GetappImport.validate_arguments(["capterra", "priv/not_found"])
      assert {:error, :file_not_found} == GetappImport.validate_arguments(["capterra", ""])
    end
  end

  describe "read_file/2" do
    @tag :wip
    test "test" do
      GetappImport.read_file(:capterra, "priv/feed_products/capterra.yaml")
    end
  end

end
