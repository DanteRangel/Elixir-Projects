defmodule Frequency.Worker do
  use GenServer

  ## Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def publish(message) do
    GenServer.cast(Frequency.Worker, {:publish, message})
  end

  ## Server Callbacks

  def init(stack) do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, "channel_1")
    {:ok, %{channel: channel, connection: connection} }
  end


  def handle_cast({:publish, message}, state) do
    AMQP.Basic.publish(state.channel, "", "channel_1", message)
    IO.puts("Handle_cast #{message}")
    {:noreply, state}
  end

  def terminate(_reason, state) do
    AMQP.Connection.close(state.connection)
  end
end
