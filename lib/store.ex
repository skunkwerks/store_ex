defmodule Store do
  @moduledoc """
  Welcome to Store!

  Store is a minimal Elixir application designed to help you get started
  with behaviours and hot code upgrades. The commits are carefully
  arranged in small easy-to-understand steps.
  """
  use Application
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

  @doc """
  Puts a key/value into the Store.
  Takes key, value parameters.
  Returns :ok or {:error, reason} if unable to continue.
  """
  def put(key, value) do
    :gen_server.cast(__MODULE__, { :put, key, value})
  end

  @doc """
  Gets a key's corresponding value from the Store.
  Takes key parameter.
  Returns value or :nil if key is not present.
  """
  def get(key) do
    :gen_server.call(__MODULE__, { :get, key})
  end

  @doc """
  Deletes a key/value from the Store.
  Takes key parameter.
  Returns :ok.
  """
  def delete(key) do
    :gen_server.cast(__MODULE__, { :delete, key})
  end

  @doc """
  Retrieves the GenServer internal state.
  No parameters.
  Returns status.
  """
  def introspect do
    :sys.get_status __MODULE__
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

  ############################################################################## 
  # GenServer Callbacks

  # synchronous - wait for a reply
  def handle_call( {:get, key}, _from, dict) do
    { :reply, dict[key] , dict }
  end

  def handle_call(request, from, config) do
    # Call the default implementation from GenServer.Behaviour
    super(request, from, config)
  end

  # asynchronous - no waiting
  def handle_cast({ :put, key, value }, dict) do
    dict = HashDict.put(dict, key, value)
    { :noreply, dict }
  end

  def handle_cast({ :delete, key}, dict) do
    dict = HashDict.delete(dict, key)
    { :noreply, dict }
  end

  # required for our Store.stop function
  def handle_cast( {:stop} , state) do
    { :stop, :normal, state }
  end

  # not strictly required but if we replace the hashdict setup
  # with something fancier in future that *does* need termination
  def terminate(:normal, _state) do
    :ok
  end
end
