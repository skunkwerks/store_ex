defmodule Store do
  @moduledoc """
  Welcome to Store!

  Store is a minimal Elixir application designed to help you get started
  with behaviours and hot code upgrades. The commits are carefully
  arranged in small easy-to-understand steps.
  """
  
  @doc """
  Initialises a new Store service.
  Takes no parameters.
  Returns :ok or {:error, reason} if unable to continue.
  Should be used on module load only.
  """
  def init() do
    :ok
  end
end
