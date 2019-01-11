defmodule FacturasTest do
  use ExUnit.Case
  doctest Facturas

  import Facturas.CLI, only: [ parse_args: 1 ]

#
# Test de Facturas.Factura
#
  alias Facturas.Factura

  test "Crea factura" do
    assert Factura.new == %Factura{}
  end

  test "Modificar concepto de factura" do
    factura =
      Factura.new
        |> Factura.concepto("Test concepto")

    assert Map.get(factura, :concepto) == "Test concepto"
  end

  test "Modificar fecha de factura" do
    factura =
      Factura.new
        |> Factura.date("2012-01-01")

    assert Map.get(factura, :fecha) == ~D[2012-01-01]
  end

  test "Modificar id cliente de factura" do
    factura =
      Factura.new
        |> Factura.id_cliente(200)

    assert Map.get(factura, :id_cliente) == 200
  end

  test "Modificar id de factura" do
    factura =
      Factura.new
        |> Factura.id(22300)

    assert Map.get(factura, :id) == 22300
  end

  test "Modificar importe de factura y redondeo" do
    factura =
      Factura.new
        |> Factura.importe(234.2260)

    assert Map.get(factura, :importe) == 234.23
  end

  test "Modificar iva de factura y redondeo" do
    factura =
      Factura.new
        |> Factura.iva(23.2360)

    assert Map.get(factura, :iva) == 23.24
  end

  test "Modificar irpf de factura y redondeo" do
    factura =
      Factura.new
        |> Factura.irpf(23.2360)

    assert Map.get(factura, :irpf) == 23.24
  end

  test "Modificar pagada" do
    factura =
      Factura.new
        |> Factura.pagada(true)

    assert Map.get(factura, :pagada) == true
  end

  test "Modificar fecha factura al dia de hoy" do
    date = Date.utc_today

    factura =
      Factura.new
        |> Factura.today

    assert Map.get(factura, :fecha) == date
  end

  test "Datos por defecto son correctos" do
    factura = Factura.new

    assert Map.get(factura, :concepto) == ""
    assert Map.get(factura, :fecha) == nil
    assert Map.get(factura, :id) == 0
    assert Map.get(factura, :id_cliente) == 0
    assert Map.get(factura, :importe) == 0
    assert Map.get(factura, :irpf) == 7
    assert Map.get(factura, :iva) == 21
    assert Map.get(factura, :pagada) == false
  end

  test "crear factura" do
    # lista_fact = Facturas.ListFacturas.new()
    factura    = Facturas.Factura.crear("2018-12-12", 1, 124.33, true, "Test Facturas")
    assert factura == %Facturas.Factura{
      id: 0,
      concepto: "Test Facturas",
      fecha: ~D[2018-12-12],
      id_cliente: 1,
      importe: 124.33,
      pagada: true,
      irpf: 7,
      iva: 21
    }
  end

#
# Test FacturasList
#
alias Facturas.FacturasList

  test "Crea nueva lista con valores por defecto" do
    assert FacturasList.new == %FacturasList{ id: 1, lista: [] }
  end

  test "add factura a lista añade factura y modifica los id de factura y lista" do
    f = Factura.new()
    list =
      FacturasList.new()
      |> FacturasList.add_entry(f)

    assert Map.get(list, :id) == 2
    assert Map.get(list, :lista) == [%{f|id: 1}]
  end

  test "lista pagadas vacia" do
    f = Factura.new()
    list =
      FacturasList.new()
      |> FacturasList.add_entry(f)

    list = FacturasList.pagadas(list)

    assert length(list.lista) == 0
  end

  test "lista pagadas no vacia" do
    f = Factura.new()|>Factura.pagada(true)

    list =
      FacturasList.new()
      |> FacturasList.add_entry(f)

    list = FacturasList.pagadas(list)
    assert length(list.lista) == 1
  end

  test "lista no pagadas no vacia" do
    f = Factura.new()
    list =
      FacturasList.new()
      |> FacturasList.add_entry(f)

    list = FacturasList.no_pagadas(list)

    assert length(list.lista) == 1
  end

  test "lista no pagadas vacia" do
    f = Factura.new()|>Factura.pagada(true)

    list =
      FacturasList.new()
      |> FacturasList.add_entry(f)

    list = FacturasList.no_pagadas(list)
    assert length(list.lista) == 0
  end

  test "Calcula el total de pagadas" do
    f1 = Factura.new() |> Factura.importe(100.10) |> Factura.pagada(true)
    f2 = Factura.new() |> Factura.importe(100.20) |> Factura.pagada(true)
    f3 = Factura.new() |> Factura.importe(100.356) |> Factura.pagada(true)

    lista =
      FacturasList.new()
      |> FacturasList.add_entry(f1)
      |> FacturasList.add_entry(f2)
      |> FacturasList.add_entry(f3)

    assert FacturasList.total_pagadas(lista) == 300.66
  end

  test "Calcula el total de no pagadas" do
    f1 = Factura.new() |> Factura.importe(100.10)
    f2 = Factura.new() |> Factura.importe(100.20)
    f3 = Factura.new() |> Factura.importe(100.356)

    lista =
      FacturasList.new()
      |> FacturasList.add_entry(f1)
      |> FacturasList.add_entry(f2)
      |> FacturasList.add_entry(f3)

    assert FacturasList.total_no_pagadas(lista) == 300.66
  end

  test "Calcula el irpf" do
    f1 = Factura.new() |> Factura.importe(50.00)
    f2 = Factura.new() |> Factura.importe(100.00) |> Factura.pagada(true)
    f3 = Factura.new() |> Factura.importe(50.00)

    lista =
      FacturasList.new()
      |> FacturasList.add_entry(f1)
      |> FacturasList.add_entry(f2)
      |> FacturasList.add_entry(f3)

    assert FacturasList.irpf(lista) == 14.00
  end

  test "Calcula el iva" do
    f1 = Factura.new() |> Factura.importe(50.00)
    f2 = Factura.new() |> Factura.importe(100.00) |> Factura.pagada(true)
    f3 = Factura.new() |> Factura.importe(50.00)

    lista =
      FacturasList.new()
      |> FacturasList.add_entry(f1)
      |> FacturasList.add_entry(f2)
      |> FacturasList.add_entry(f3)

    assert FacturasList.iva(lista) == 42.00
  end

  test ":help es retornado con la opcion -h y --help" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["--help"]) == :help
  end

  #
  # test "carga fichero facturas.csv sin parametros" do
  #   datos = Facturas.CLI.run([""])
  #
  #   assert datos == %Facturas.ListFacturas{
  #            file: "/Users/ismqui/dev/elixir/facturas.csv",
  #            id: 0,
  #            lista: []
  #          }
  # end

end
