defmodule Store do
  @moduledoc """
  Welcome to Store!

  Store is a minimal Elixir application designed to help you get started
  with behaviours and hot code upgrades. The commits are carefully
  arranged in small easy-to-understand steps.
  """
  use GenServer.Behaviour

  ##############################################################################
  # External API

  @doc """
  Initialises a new Store service.
  Takes no parameters.
  Returns {:ok, pid()) or {:error, reason} if unable to continue.
  """
  def start() do
    start(:normal, :nil)
  end

  @doc """
  Terminates a new Store service.
  Takes no parameters.
  Returns :ok or {:error, reason} if unable to continue.
  """
  def stop do
    case is_pid(Process.whereis(__MODULE__)) do
      true  -> :gen_server.cast(__MODULE__, {:stop})
      false -> :ok
    end
  end

  ##############################################################################
  # Application Callbacks

  def start(_, _) do
    dict = HashDict.new
    case :gen_server.start_link({:local, __MODULE__}, __MODULE__, dict , []) do
      {:ok, pid}                        -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
    end
  end
  end
end
