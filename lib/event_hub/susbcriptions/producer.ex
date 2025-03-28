defmodule EventHub.Subscriptions.Producer do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: SubscriptionsProducer,
      context: EventHub.Notifications.Notification,
      producer: [
        module: {BroadwayRabbitMQ.Producer,
          queue: "project-dev-pending_subscriptions-v1",
          qos: [
            prefetch_count: 50,
          ],
          on_failure: :reject
        },
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 1500,
          concurrency: 5
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, context) do
    IO.inspect(message.data, label: "Received message!")
    message =
      message
      |> Message.update_data(fn data -> data end)

    apply(context, :handle_message, [message])

    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)
    IO.inspect(list, label: "Got batch")
    messages
  end
end
