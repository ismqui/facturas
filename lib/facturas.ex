defmodule Facturas do
  @moduledoc """
  Documentation for Facturas.
  """
  # defdelegate inicio(argv\\[""]), to: Facturas.CLI, as: :run
  defdelegate inicio(n), to: Facturas.CLI, as: :main

end
