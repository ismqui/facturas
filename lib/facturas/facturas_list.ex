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

  def add_entry(%FacturasList{ id: _id, lista: _lista} = fact_list, %Factura{} = factura) do
    f = Factura.id(factura, fact_list.id)
    %FacturasList{ id: fact_list.id + 1, lista: [ f | fact_list.lista ] }
  end

  def add_entries(%FacturasList{ id: _id, lista: _lista} = fact_list, []) do
    fact_list
  end

  def add_entries(%FacturasList{ id: _id, lista: _lista} = fact_list, [head|tail] ) do
    add_entry(fact_list, head)
    |> add_entries(tail)
  end

  def pagadas(%FacturasList{ id: id, lista: lista}) do
    lista =
      lista
      |> Enum.filter(fn x -> Factura.pagada?(x) end)

    %FacturasList{
      id: id,
      lista: lista
    }
  end

  def no_pagadas(%FacturasList{ id: id, lista: lista}) do
    lista =
      lista
      |> Enum.filter(fn x -> !Factura.pagada?(x) end)

    %FacturasList{
      id: id,
      lista: lista
    }
  end

  def total(%FacturasList{ id: _id, lista: _lista} = lista_fact) do
    lista_fact.lista
      |>Enum.reduce(0, fn x, acc -> Factura.get_importe(x) + acc end)
      |>Float.round(2)
  end

  def total_pagadas(%FacturasList{ id: _id, lista: _lista} = lista_fact) do
    lista_fact
      |>pagadas()
      |>total()
  end

  def total_no_pagadas(%FacturasList{ id: _id, lista: _lista} = lista_fact) do
    lista_fact
      |>no_pagadas()
      |>total()
  end

  def irpf(%FacturasList{ id: _id, lista: lista}) do
    lista
      |>Enum.reduce(0, fn x, acc -> Factura.calcula_irpf(x) + acc end)
      |>Float.round(2)
  end

  def iva(%FacturasList{ id: _id, lista: lista}) do
    lista
      |>Enum.reduce(0, fn x, acc -> Factura.calcula_iva(x) + acc end)
      |>Float.round(2)
  end

end
