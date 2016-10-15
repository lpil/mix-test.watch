defmodule MixTestWatch.MessageInboxTest do
  use ExUnit.Case
  alias MixTestWatch.MessageInbox

  test "flush clears the process inbox of messages" do
    Enum.each 1..10, &send(self(), &1)
    MessageInbox.flush()
    refute_received _any_messages
  end
end
