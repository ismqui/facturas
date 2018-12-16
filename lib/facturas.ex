defmodule Facturas do
  defstruct [
    id: 0,
    fecha: nil,
    id_cliente: 0,
    importe: 0,
    concepto: "",
    pagada: false,
  ]
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

  def concepto(factura, concepto) do
    %Facturas{ factura | concepto: concepto }
  end

  def date(factura, date) do
    %Facturas{factura | fecha: date }
  end

  def today(factura) do
    date = DateTime.utc_now |> DateTime.to_date
    %Facturas{factura | fecha: date }
  end

  def id(factura, id) do
    %Facturas{factura | id: id }
  end

  def id_cliente(factura, id_cliente) do
    %Facturas{factura | id_cliente: id_cliente }
  end

  def importe(factura, importe) do
    %Facturas{factura | importe: importe }
  end

  def pagada(factura, pagada) do
    %Facturas{factura | pagada: pagada }
  end

  def create(factura, id, id_cliente, importe, pagada, concepto) do
    factura
    |> id(id)
    |> id_cliente(id_cliente)
    |> importe(importe)
    |> pagada(pagada)
    |> concepto(concepto)
    |> today()
  end

end
