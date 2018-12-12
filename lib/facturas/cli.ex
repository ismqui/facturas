defmodule Facturas.CLI do

  @moduledoc """
  Controla el parsing de la linea de comandos y la
  llamada a las distintas funciones que terminan
  generando la factura
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` puede ser -h o --help, que devuelve :help.

  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _, _}
        -> :help

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    utilización: facturas <nolosétodavia>
    """
    System.halt(0)
  end

  def process(:list) do
    Facturas.lista()
  end
end
