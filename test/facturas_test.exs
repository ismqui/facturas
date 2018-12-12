defmodule FacturasTest do
  use ExUnit.Case
  doctest Facturas

  import Facturas.CLI, only: [ parse_args: 1 ]

  test ":help es retornado con la opcion -h y --help" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "lista todas las facturas existentes" do
    assert Facturas.lista == [%{ id: 1,
                                  fecha: "2018-12-12",
                                  id_cliente: 1,
                                  concepto: "servicios informaticos"}]
  end
end
