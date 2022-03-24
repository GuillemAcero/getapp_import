defmodule GetappImportTest do
  use ExUnit.Case

  describe "main/1" do
    test "error when number of arguments invalid" do
      assert {:error, :invalid_number_of_arguments} == GetappImport.main("arg1")

      assert {:error, :invalid_number_of_arguments} ==
               GetappImport.main(["arg1", "arg2", "arg3"])
    end

    test "error when the provider is invalid" do
      assert {:error, :invalid_provider} == GetappImport.main(["invalid", "path"])
      assert {:error, :invalid_provider} == GetappImport.main([:invalid, "path"])
      assert {:error, :invalid_provider} == GetappImport.main([1234, "path"])
    end

    test "error if file path is invalid" do
      assert {:error, :invalid_path_type} ==
               GetappImport.main(["capterra", :not_a_path])

      assert {:error, :invalid_path_type} == GetappImport.main(["capterra", 12345])
    end

    test "error if file does not exist" do
      assert {:error, :file_not_found} ==
               GetappImport.main(["capterra", "priv/not_found"])

      assert {:error, :file_not_found} == GetappImport.main(["capterra", ""])
    end

    test "error if file for provider capterra is not yaml" do
      assert {:error, :file_bad_extension} ==
               GetappImport.main(["capterra", "priv/test_products/invalid.ex"])
    end

    test "error if file for provider softwareadvice is json" do
      assert {:error, :file_bad_extension} ==
               GetappImport.main(["softwareadvice", "priv/test_products/invalid.ex"])
    end

    test "error if yaml file have bad structure" do
      assert {:error, :file_bad_structure} ==
               GetappImport.main(["capterra", "priv/test_products/invalid.yaml"])
    end

    test "error if json file have bad structure" do
      assert {:error, :file_bad_structure} ==
               GetappImport.main(["softwareadvice", "priv/test_products/invalid.json"])
    end

    test "returns a list of products if everything's ok (capterra)" do
      assert {:ok, list} = GetappImport.main(["capterra", "priv/feed_products/capterra.yaml"])
      assert length(list) == 3
    end

    test "returns a list of products if everything's ok (softwareadvice)" do
      assert {:ok, list} =
               GetappImport.main(["softwareadvice", "priv/feed_products/softwareadvice.json"])

      assert length(list) == 2
    end
  end
end
