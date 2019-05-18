defmodule Facturas.CLI do

  @moduledoc """
  Controla el parsing de la linea de comandos y la
  llamada a las distintas funciones que terminan
  generando la factura
  """

  @fichero  "facturas.csv"
  @dir  "/Users/ismqui/dev/elixir"

  def main(_args) do
    IO.puts("Bienvenido al programa de facturas")
    print_help_message()
    Facturas.FacturasFile.load("#{@dir}/#{@fichero}")
    |> receive_command()
  end

  @commands %{
    "quit" => "Quits programa facturas",
    "list" => "Lista facturas",
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

  defp execute_command(["list"],
       %Facturas.FacturasFile{facturas_list: %Facturas.FacturasList{ id: _, lista: lista}} = facturas) do
    lista
    |> Enum.map(&IO.inspect(&1))

    receive_command(facturas)
  end

  defp execute_command(["pagadas"], %Facturas.FacturasFile{facturas_list: lista} = facturas) do
    lista
    |> Facturas.FacturasList.pagadas()
    |> IO.inspect()

    receive_command(facturas)
  end

  defp execute_command(["nopagadas"], %Facturas.FacturasFile{facturas_list: lista} = facturas) do
    lista
    |> Facturas.FacturasList.no_pagadas()
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
    |> Enum.map(fn({command, descripcion}) -> IO.puts(" #{command} - #{descripcion}") end)
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

    Facturas.FacturasFile.load("#{dir}/#{file}")
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
    Facturas.FacturasFile.load("#{dir}/#{file}")
  end

  def process({:file, name}) do
    file   = name
    dir    = "/Users/ismqui/dev/elixir"
    Facturas.FacturasFile.load("#{dir}/#{file}")
  end
end
