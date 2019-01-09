defmodule Facturas.Factura do
  defstruct [
      id: 0,
      fecha: nil,
      id_cliente: 0,
      concepto: "",
      importe: 0,
      pagada: false,
      irpf: 7,
      iva: 21
    ]

  alias Facturas.Factura

  def new(), do: %Factura{}

  def concepto(factura, concepto) do
    %Factura{ factura | concepto: concepto }
  end

  def date(factura, date) do
    {:ok, date} = Date.from_iso8601(date)
    %Factura{factura | fecha: date }
  end

  def today(factura) do
    date = DateTime.utc_now |> DateTime.to_date
    %Factura{factura | fecha: date }
  end

  def id(factura, id) do
    %Factura{factura | id: id }
  end

  def id_cliente(factura, id_cliente) do
    %Factura{factura | id_cliente: id_cliente }
  end

  def importe(factura, importe) do
    %Factura{factura | importe: importe }
  end

  def pagada(factura, pagada) do
    %Factura{factura | pagada: pagada }
  end

  def crear(fecha, id_cliente, importe, pagada, concepto) do
    Factura.new
    |> Factura.date(fecha)
    |> Factura.id_cliente(id_cliente)
    |> Factura.importe(importe)
    |> Factura.pagada(pagada)
    |> Factura.concepto(concepto)

    # %Factura{
    #   id: 0,
    #   fecha: fecha,
    #   id_cliente: id_cliente,
    #   importe: importe,
    #   pagada: pagada,
    #   concepto: concepto
    # }
  end

end
