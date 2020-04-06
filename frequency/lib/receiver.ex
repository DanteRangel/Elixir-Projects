defmodule Receiver do
  def wait_for_messages do
    channel_name = "channel_1"
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, channel_name)
    AMQP.Basic.consume(channel, channel_name, nil, no_ack: true)
    Agent.start_link(fn -> [] end, name: :batcher)
    IO.inspect(connection)
    IO.inspect(channel)
    wait_for_messages_re()
  end

  def hola do
    "hola"
  end

  defp push(value) do
    Agent.update(:batcher, fn list -> [value|list] end)
    flush_if_full()
  end

  defp flush do
    Agent.update(:batcher, fn _ -> [] end)
  end

  defp full? do
    Agent.get(:batcher, fn list -> length(list) > 10 end)
  end

  defp make_key do
    rand = :crypto.strong_rand_bytes(6) |> Base.url_encode64
    now = DateTime.utc_now |> DateTime.to_unix
    "batch_#{now}_#{rand}.json"
  end

  defp write_and_upload(json) do
    File.write("./#{make_key}", json)
  end

  defp flush_if_full do
    if full?() do
      l = Agent.get(:batcher, fn list -> list end)
      {:ok, json} = Jason.encode(l)
      write_and_upload(json)
      flush()
    end
  end

  def wait_for_messages_re do
    receive do
      {:basic_deliver, payload, _meta} ->
        push(payload)
        IO.puts "received a message!"
        wait_for_messages_re()
    end
  end
end
