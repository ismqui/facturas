defmodule Facturas do
  @moduledoc """
  Documentation for Facturas.
  """
  defdelegate inicio(argv), to: Facturas.CLI, as: :run

end
