defmodule Facturas.ListFacturas do
  defstruct [
    file: "",
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

  def add_lista(%ListFacturas{file: file, id: id, lista: lista} = lista_fact, factura) do
    f = %Factura{ factura|id: lista_fact.id }
    %ListFacturas{ file: file, id: lista_fact.id + 1, lista: [ f | lista_fact.lista ] }
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

    %ListFacturas{file: file, id: mayor.id + 1, lista: lista}
  end

  def save_csv(%{file: file, id: id, lista: lista} = data) do
    new_file = new_name_file(file)
    lista
      |>Enum.sort(&(&1.id <= &2.id))
      |>Enum.map(fn x -> File.write(new_file, "#{x.fecha}, #{x.id}, #{x.importe}, #{x.iva}, #{x.irpf}, #{x.pagada}, \"#{x.concepto}\"\n", [:append]) end)
  end

  def new_name_file(name) do
    fecha = DateTime.utc_now
    ext = "#{fecha.year}#{fecha.month}#{fecha.day}#{fecha.hour}#{fecha.minute}#{fecha.second}"
    String.slice(name, 0..-4)<>"#{ext}.csv"
  end

  def lista_pagadas(%ListFacturas{file: file, id: id, lista: lista} = lista_fact) do
    lista
    |> Enum.filter(fn x -> x.pagada end)
  end

  def lista_no_pagadas(%ListFacturas{file: file, id: id, lista: lista} = lista_fact) do
    lista
    |> Enum.filter(fn x -> !x.pagada end)
  end

  def total_pagadas(%ListFacturas{file: file, id: id, lista: lista} = lista_fact) do
    lista_fact
      |>lista_pagadas()
      |>Enum.reduce(0, fn x, acc -> x.importe + acc end)
  end

  def total_no_pagadas(%ListFacturas{file: file, id: id, lista: lista} = lista_fact) do
    lista_fact
      |>lista_no_pagadas()
      |>Enum.reduce(0, fn x, acc -> x.importe + acc end)
  end

  def irpf(%ListFacturas{file: file, id: id, lista: lista} = lista_fact) do
    lista_fact
      |>lista_pagadas()
      |>Enum.reduce(0, fn x, acc -> ((x.importe * x.irpf) / 100) + acc end)
      |>Float.round(2)
  end

  def iva(%ListFacturas{file: file, id: id, lista: lista} = lista_fact) do
    lista_fact
      |>lista_pagadas()
      |>Enum.reduce(0, fn x, acc -> ((x.importe * x.iva) / 100) + acc end)
      |>Float.round(2)
  end
  
end
