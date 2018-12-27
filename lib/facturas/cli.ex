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

    parse = OptionParser.parse(argv, switches: [ help: :boolean,
                                                 file: :string,
                                               ],
                                     aliases:  [ h:    :help,
                                                 f:    :string
                                               ])

    IO.inspect(parse)

    case parse do
      { [ file: name ], _, _ }
        -> { :file, name }
      { opts, _, _ }
        -> options(opts)
      { [ help: true ], _, _}
        -> :help

      _ -> IO.inspect(parse)
           :help
    end
  end

  def options(opts) do
    IO.inspect opts
    inicio = opts[:di]    || "2000-01-01"
    fin    = opts[:df]    || "3000-01-01"
    file   = opts[:file]  || "facturas.csv"
    dir    = opts[:dir]   || "/Users/username/elixir"

    IO.puts "opciones: #{inicio}, #{fin}, #{file}, #{dir}."
    {inicio, fin, file, dir}
  end

  def process(:help) do
    IO.puts """
    utilización: facturas <nolosétodavia>
    """
    # System.halt(0)
  end

  def process({:file, name}) do
    Facturas.ListFacturas.crear(name)
  end

  def process({inicio, fin, file, dir}) do
    IO.puts "opciones: #{inicio}, #{fin}, #{file}, #{dir}."
    Facturas.ListFacturas.crear("#{dir}/#{file}")
  end
end
