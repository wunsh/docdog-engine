defmodule DocdogWeb.ErrorHelpersTest do
  use DocdogWeb.ConnCase, async: true

  import DocdogWeb.ErrorHelpers

  test "error_tag/2 renders tag with translated error" do
    errors = %{errors: [email: {"can't be blank", [validation: :required]}]}
    assert [{:safe, _}] = error_tag(errors, :email)
  end

  describe "translate_error/1" do
    test "translates error message" do
      error = {"can't be blank", %{}}
      assert translate_error(error) == "can't be blank"
    end

    test "translates error message with count interpolation" do
      error = {"can't be blank when count > %{count}", %{count: 3}}
      assert translate_error(error) == "can't be blank when count > 3"
    end
  end
end
