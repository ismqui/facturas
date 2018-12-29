defmodule Facturas.ListFacturas do
  defstruct [
    id: 1,
    lista: []
  ]

  alias Facturas.Factura
  alias Facturas.ListFacturas

  def new() do
    %ListFacturas{}
  end

  def add(lista, factura) do
    f = %Factura{ factura|id: lista.id }
    %ListFacturas{ id: lista.id + 1, lista: [ f | lista.lista ] }
  end

  def read(file) do
    file
    |> File.stream!
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def format_data(input) do
    format_facturas = fn(el, acc) ->
      [fecha, id, importe, pagada, concepto] = String.split(el, ",")
      fecha = Date.from_iso8601!(fecha)
      id = String.trim(id) |> String.to_integer
      importe = String.trim(importe) |> String.to_float
      pagada = String.trim(pagada) |> String.to_existing_atom
      concepto = String.trim(concepto) |> String.replace("\"", "")

      factura = %Factura{
        id: id,
        fecha: fecha,
        importe: importe,
        pagada: pagada,
        concepto: concepto
      }
      acc =[ factura | acc ]
    end

    Enum.reduce(input, [], format_facturas)
  end

  def load(file) do
    lista = file
      |> ListFacturas.read()
      |> ListFacturas.format_data()

    mayor = Enum.sort(lista, &(&1.id >= &2.id)) |> List.first()

    %ListFacturas{id: mayor.id + 1, lista: lista}
  end
end
