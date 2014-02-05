defmodule StoreTest do

  @empty_store "Store.put(:foo, :baa, [])"
  @small_store "Store.put(:foo, :baa, @empty_store)"
  @large_store "Store.put(:few, :bar, @small_store)"

  use ExUnit.Case

  test "init/0 returns OK" do
    assert Store.init == :ok
  end
end
