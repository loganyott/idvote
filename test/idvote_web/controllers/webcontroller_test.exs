defmodule IdvoteWeb.WebControllerTest do
  use IdvoteWeb.ConnCase, async: true

  @dummy_address "123 Joe Dirt Rd"

  import Tesla.Mock

  @mock_location %{
    "features" => [
      %{
        "center" => [5, 5]
      }
    ]
  }

  setup do
    mock(fn
      %{method: :get} ->
        %Tesla.Env{status: 200, body: @mock_location}
    end)

    :ok
  end

  test "you can send an address and recieve a response", %{conn: conn} do
    conn = post(conn, "/api/find", %{"address" => @dummy_address})

    assert conn.status === 200
    assert ["address", "name", "date", "precinct", "opening_time", "closing_time"] |> Enum.all?(&(Map.has_key?(Jason.decode!(conn.resp_body), &1)))
  end
end
