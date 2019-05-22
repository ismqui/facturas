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
    date = Date.utc_today
    %Factura{factura | fecha: date }
  end

  def id(factura, id) do
    %Factura{factura | id: id }
  end

  def id_cliente(factura, id_cliente) do
    %Factura{factura | id_cliente: id_cliente }
  end

  def importe(factura, importe) do
    %Factura{factura | importe: Float.round(importe,2) }
  end

  def irpf(factura, irpf) do
    %Factura{factura | irpf: Float.round(irpf,2) }
  end

  def iva(factura, iva) do
    %Factura{factura | iva: Float.round(iva,2) }
  end

  def pagada(factura, pagada) do
    %Factura{factura | pagada: pagada }
  end

  def pagada?(factura) do
    factura.pagada
  end

  def get_importe(factura) do
    factura.importe
  end

  def crear(fecha, id_cliente, importe, pagada, concepto) do
    Factura.new
    |> Factura.date(fecha)
    |> Factura.id_cliente(id_cliente)
    |> Factura.importe(importe)
    |> Factura.pagada(pagada)
    |> Factura.concepto(concepto)
  end

end
