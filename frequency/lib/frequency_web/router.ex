defmodule FrequencyWeb.Router do
  use FrequencyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FrequencyWeb do
    pipe_through :api
    post "/t", TracksController, :index
  end
end
