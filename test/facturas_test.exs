defmodule FacturasTest do
  use ExUnit.Case
  doctest Facturas

  import Facturas.CLI, only: [ parse_args: 1 ]

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

  test "crear factura" do
    # lista_fact = Facturas.ListFacturas.new()
    factura    = Facturas.Factura.crear("2018-12-12", 1, 124.33, true, "Test Facturas")
    assert factura == %Facturas.Factura{
      id: 0,
      concepto: "Test Facturas",
      fecha: ~D[2018-12-12],
      id_cliente: 1,
      importe: 124.33,
      pagada: true
    }
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
