defmodule Facturas do
  @moduledoc """
  Documentation for Facturas.
  """

  def lista() do
    [
      %{ id: 1,
        fecha: "2018-12-12",
        id_cliente: 1,
        concepto: "servicios informaticos" }
    ]
  end
end
