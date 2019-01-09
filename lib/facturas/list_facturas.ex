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
