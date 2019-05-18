defmodule Facturas.CLI do

  @moduledoc """
  Controla el parsing de la linea de comandos y la
  llamada a las distintas funciones que terminan
  generando la factura
  """

  alias Facturas.FacturasFile
  alias Facturas.FacturasList

  @fichero  "facturas.csv"
  @dir  "/Users/ismqui/dev/elixir"

  def main(_args) do
    IO.puts("Bienvenido al programa de facturas")
    print_help_message()
    FacturasFile.load("#{@dir}/#{@fichero}")
    |> receive_command()
  end

  @commands %{
    "quit" => "Finaliza programa facturas",
    "list" => "Lista facturas",
    "iva" => "Calcula iva facturas",
    "irpf" => "Calcula irpf facturas",
    "pagadas" => "Lista facturas pagadas",
    "nopagadas" => "Lista facturas NO pagadas"
  }

  defp receive_command(facturas \\ nil) do
    IO.gets("\n>")
    |> String.trim
    |> String.downcase
    |> String.split(" ")
    |> execute_command(facturas) 
  end

  defp execute_command(["quit"], _facturas) do
    IO.puts("\nFinalizando facturación.")
  end

  defp execute_command(["list"], facturas) do
#    %FacturasFile{facturas_list: %FacturasList{ id: _, lista: lista}} = facturas) do

    facturas
    |> format_output() 

    receive_command(facturas)
  end

  defp format_output(
    %FacturasFile{facturas_list: %FacturasList{ id: _, lista: lista}} = facturas) do

    cabecera = "\t| id |         concepto          |    importe    |   irpf   |   iva    | p |" 
    footer   = "\t|                                |               |          |          |   |" 
    linea    = "\t----------------------------------------------------------------------------"
    IO.puts(linea)
    IO.puts(cabecera)
    IO.puts(linea)
    lista
    |> Enum.map(
       fn reg -> 
         id = reg.id |> Integer.to_string |> String.pad_leading(3, "0")
         concepto = reg.concepto |> String.pad_trailing(25, " ")
         importe = reg.importe |> Float.to_string |> String.pad_leading(12, " ")
         iva  = ((reg.iva * reg.importe)/100)
                |> Float.round(2) |> Float.to_string |> String.pad_leading(7, " ")
         irpf = ((reg.irpf * reg.importe)/100)
                |> Float.round(2) |> Float.to_string |> String.pad_leading(7, " ")
         pagada = if reg.pagada, do: "Y", else: "N"
         IO.puts("\t|#{id} | #{concepto} | #{importe}€ | #{irpf}€ | #{iva}€ | #{pagada} |")
       end
    )
    IO.puts(linea)
    IO.puts(footer)
    IO.puts(linea)
  end

  defp execute_command(["pagadas"], %FacturasFile{facturas_list: lista} = facturas) do
    lista_pagadas =
      lista
      |> FacturasList.pagadas()

    %FacturasFile{facturas_list: lista_pagadas}
    |> format_output() 

    total_pagadas =
      lista_pagadas
      |> FacturasList.total()

    IO.puts("\t Total facturas pagadas: #{total_pagadas}")

    receive_command(facturas)
  end

  defp execute_command(["nopagadas"], %FacturasFile{facturas_list: lista} = facturas) do
    lista_no_pagadas =
      lista
      |> Facturas.FacturasList.no_pagadas()

    %FacturasFile{facturas_list: lista_no_pagadas}
    |> format_output() 

    total_no_pagadas =
      lista_no_pagadas
      |> FacturasList.total()

    IO.puts("\t Total facturas no pagadas: #{total_no_pagadas}")

    receive_command(facturas)
  end

  defp execute_command(["irpf"], %FacturasFile{facturas_list: lista} = facturas) do
    lista
    |> FacturasList.irpf()
    |> IO.inspect()

    receive_command(facturas)
  end

  defp execute_command(["iva"], %FacturasFile{facturas_list: lista} = facturas) do
    lista
    |> FacturasList.iva()
    |> IO.inspect()

    receive_command(facturas)
  end

  defp execute_command(_unknown, facturas) do
    IO.puts("\nComando invalido.")
    print_help_message()

    receive_command(facturas)
  end

  defp print_help_message do
    IO.puts("\nEl programa acepta los siguientes comandos:\n")
    @commands
    |> Enum.map(fn({command, descripcion}) -> IO.puts(" #{command}        \t - #{descripcion}") end)
  end

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

    case parse do
      {[help: true], _, _} ->
        :help

      {[list: true], _, _} ->
        :list

      {[file: name, list: true], _, _} ->
        {:file, name}

      {opts, _, _} ->
        {:options, opts}

      _ ->
        IO.inspect(parse)
        :help
    end

  end

  def process({:options, opts}) do
    # inicio = opts[:di]    || "2000-01-01"
    # fin    = opts[:df]    || "3000-01-01"
    file   = opts[:file]  || "facturas.csv"
    dir    = opts[:dir]   || "/Users/ismqui/dev/elixir"

    FacturasFile.load("#{dir}/#{file}")
  end

  def process(:help) do
    IO.puts """
    utilización: facturas -l [-f nombre_file --di 2018-01-01 --df 2019-01-01 ]
    """
    # System.halt(0)
  end

  def process(:list) do
    file   = "facturas.csv"
    dir    = "/Users/ismqui/dev/elixir"
    FacturasFile.load("#{dir}/#{file}")
  end

  def process({:file, name}) do
    file   = name
    dir    = "/Users/ismqui/dev/elixir"
    FacturasFile.load("#{dir}/#{file}")
  end
end
