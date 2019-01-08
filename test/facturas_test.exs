defmodule FacturasTest do
  use ExUnit.Case
  doctest Facturas

  import Facturas.CLI, only: [ parse_args: 1 ]

  test ":help es retornado con la opcion -h y --help" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["--help"]) == :help
  end

  test "lista todas las facturas existentes" do
    lista_fact = Facturas.ListFacturas.new()
    factura    = Facturas.Factura.crear("2018-12-12", 1, 124.33, true, "Test Facturas")
    assert factura == %Facturas.Factura{
      id: 0,
      concepto: "Test Facturas",
      fecha: "2018-12-12",
      id_cliente: 1,
      importe: 124.33,
      pagada: true
    }
  end

  test "carga fichero facturas.csv sin parametros" do
    datos = Facturas.CLI.run([""])

    assert datos == %Facturas.ListFacturas{
             file: "/Users/ismqui/dev/elixir/facturas.csv",
             id: id,
             lista: lista
           }
  end

end
