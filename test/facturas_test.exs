defmodule FacturasTest do
  use ExUnit.Case
  doctest Facturas

  import Facturas.CLI, only: [ parse_args: 1 ]

  test ":help es retornado con la opcion -h y --help" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
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
end
