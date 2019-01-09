defmodule Facturas.FacturasList do
  defstruct [
    id: 1,
    lista: []
  ]

  alias Facturas.Factura
  alias Facturas.FacturasList

  def new() do
    %FacturasList{}
  end

  def add_entry(%FacturasList{ id: id, lista: lista} = fact_list, %Factura{} = factura) do
    f = Factura.id(factura, fact_list.id)
    %FacturasList{ id: fact_list.id + 1, lista: [ f | fact_list.lista ] }
  end

  def pagadas(%FacturasList{ id: id, lista: lista} = lista_fact) do
    lista
    |> Enum.filter(fn x -> x.pagada end)
  end

  def no_pagadas(%FacturasList{ id: id, lista: lista} = lista_fact) do
    lista
    |> Enum.filter(fn x -> !x.pagada end)
  end

  def total_pagadas(%FacturasList{ id: id, lista: lista} = lista_fact) do
    lista_fact
      |>pagadas()
      |>Enum.reduce(0, fn x, acc -> x.importe + acc end)
      |>Float.round(2)
  end

  def total_no_pagadas(%FacturasList{ id: id, lista: lista} = lista_fact) do
    lista_fact
      |>no_pagadas()
      |>Enum.reduce(0, fn x, acc -> x.importe + acc end)
      |>Float.round(2)
  end

  def irpf(%FacturasList{ id: id, lista: lista} = lista_fact) do
    lista
      |>Enum.reduce(0, fn x, acc -> ((x.importe * x.irpf) / 100) + acc end)
      |>Float.round(2)
  end

  def iva(%FacturasList{ id: id, lista: lista} = lista_fact) do
    lista
      |>Enum.reduce(0, fn x, acc -> ((x.importe * x.iva) / 100) + acc end)
      |>Float.round(2)
  end

end
