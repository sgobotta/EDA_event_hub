defmodule EventHub.Notifications.Notification do
  alias Broadway.Message
  defstruct from: nil, to: nil, subject: nil, body: nil

  def create(from, to, subject, body) do
    %__MODULE__{from: from, to: to, subject: subject, body: body}
  end

  def send(%__MODULE__{} = notification) do
    EventHub.Accounts.UserNotifier.deliver_email_notification(notification)
  end

  def from_message(%Message{data: data}) do
    struct(__MODULE__, Jason.decode!(data, keys: :atoms))
  end

  def handle_message(%Message{} = message) do
    message
    |> from_message()
    |> send()
    |> IO.inspect(label: "Message handled")
  end
end
