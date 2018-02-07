defmodule DocdogWeb.ErrorViewTest do
  use DocdogWeb.ConnCase, async: true

  import DocdogWeb.ErrorView

  test "template_not_found/2 renders error" do
    assert "Internal server error" == template_not_found("", %{})
  end
end
