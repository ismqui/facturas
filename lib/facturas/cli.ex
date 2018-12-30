defmodule Facturas.CLI do

  @moduledoc """
  Controla el parsing de la linea de comandos y la
  llamada a las distintas funciones que terminan
  generando la factura
  """

  def run(argv) do
    argv
    |> IO.inspect(label: "Argv")
    |> parse_args
    |> IO.inspect(label: "Parse")
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
                                                 l:    :list,
                                                 f:    :file,
                                               ])

    IO.inspect(parse, label: "Parse")

    case parse do
      { [ help: true ], _, _}
      -> :help

      { [ list: true ], _, _}
      -> :list

      { [ file: name, list: true ], _, _}
      -> {:file, name}

      # { opts, _, _ }
      #   -> options(opts)

      _ -> IO.inspect(parse)
           :help
    end
  end

  def options(opts) do
    IO.inspect opts
    inicio = opts[:di]    || "2000-01-01"
    fin    = opts[:df]    || "3000-01-01"
    file   = opts[:file]  || "facturas.csv"
    dir    = opts[:dir]   || "/Users/ismqui/dev/elixir"

    {inicio, fin, file, dir}
  end

  def process(:help) do
    IO.puts """
    utilización: facturas -l [-f nombre_file]
    """
    # System.halt(0)
  end

  def process(:list) do
    file   = "facturas.csv"
    dir    = "/Users/ismqui/dev/elixir"
    Facturas.ListFacturas.load("#{dir}/#{file}")
  end

  def process({:file, name}) do
    file   = name
    dir    = "/Users/ismqui/dev/elixir"
    Facturas.ListFacturas.load("#{dir}/#{file}")
  end

  def process({inicio, fin, file, dir}) do
    IO.puts "opciones: #{inicio}, #{fin}, #{file}, #{dir}."
    Facturas.ListFacturas.load("#{dir}/#{file}")
  end
end
