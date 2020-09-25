defmodule AppExample.Chat.Supervisor do
  @moduledoc """
  create a Supervisor :
  starting a new process and sending messages to this new pid

  the Supervisor pattern. You can’t have access to its children’s pid as it will, when necessary, restart these processes (which actually means it will kill and start a new process, with a different pid)

  To access our Chat.Server process we need some way to reference it using something other than the pid

  Dynamic process creation
  支持多个 chat room

  register
    an atom local 注册

    {:global, term} register a process globally, across multiple nodes, and it relies on a local ETS table. This also means it requires synchronization across the entire cluster, which introduces some unnecessary overhead unless you actually need this behavior.

    {:via, module, term}

  process crash 时要通知 registry
    make our registry monitor all the processes it is taking care of

   https://github.com/uwiger/gproc

  {:gproc, "0.3.1"}
  defp via_tuple(room_name) do
    {:via, :gproc, {:n, :l, {:chat_room, room_name}}}
  end
  :n 一个 key 下只有一个 pid
  :l pid 不跨 cluster
  """

  use Supervisor

  def start_link do
    # 注册监督进程名 :chat_sup
    Supervisor.start_link(__MODULE__, [], name: :chat_sup)
  end

  def start_room(name) do
    Supervisor.start_child(:chat_sup, {AppExample.Chat.Server, [name]})
  end

  def init(_) do
    children = [
      # {AppExample.Chat.Server, []}
    ]
    # supervise(children, strategy: :one_for_one)
    Supervisor.init(children, strategy: :one_for_one)
  end
end
