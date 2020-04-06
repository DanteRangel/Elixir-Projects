defmodule FrequencyWeb.TracksController do
  use FrequencyWeb, :controller


  def index(conn, params) do
    {:ok, message} = Jason.encode(params)
    IO.inspect(message)
    Frequency.Worker.publish(message)
    conn
     |> text("200")
  end
end
