defmodule BouquetVerborumWeb.ErrorJSONTest do
  use BouquetVerborumWeb.ConnCase, async: true

  test "renders 404" do
    assert BouquetVerborumWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert BouquetVerborumWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
