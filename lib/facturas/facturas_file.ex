defmodule Facturas.FacturasFile do
  defstruct [
    file: "",
    facturas_list: %Facturas.FacturasList{}
  ]

  alias Facturas.Factura
  alias Facturas.FacturasFile
  alias Facturas.FacturasList

  def new() do
    %FacturasFile{}
  end

  def new(file, list) do

    f_list =
      FacturasList.new()
      |> FacturasList.add_entries(list)


    %FacturasFile {
      file: file,
      facturas_list: f_list
    }
  end

  def read(file) do
    file
    |> File.stream!
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def format_data(input) do
    format_facturas = fn(el, acc) ->
      [fecha, id, importe, iva, irpf, pagada, concepto] = String.split(el, ",")
      # formato de la fecha "yyyy-mm-dd" Factura.date(fecha) la convierte en tipo Date.
      # fecha     = Date.from_iso8601!(fecha)
      fecha     = String.trim(fecha)
      id        = String.trim(id)       |> String.to_integer
      importe   = String.trim(importe)  |> String.to_float
      iva       = String.trim(iva)      |> String.to_integer
      iva       = iva / 1       # convert the integer into float
      irpf      = String.trim(irpf)     |> String.to_integer
      irpf      = irpf / 1      # convert the integer into float
      pagada    = String.trim(pagada)   |> String.to_existing_atom
      concepto  = String.trim(concepto) |> String.replace("\"", "")

      factura =
        Factura.new()
        |> Factura.id(id)
        |> Factura.date(fecha)
        |> Factura.importe(importe)
        |> Factura.iva(iva)
        |> Factura.irpf(irpf)
        |> Factura.pagada(pagada)
        |> Factura.concepto(concepto)

      [ factura | acc ]
    end

    Enum.reduce(input, [], format_facturas)
  end

  def load(file) do
    lista = file
      |> FacturasFile.read()
      |> FacturasFile.format_data()

    mayor = Enum.sort(lista, &(&1.id >= &2.id)) |> List.first()

    %FacturasFile{file: file,
         facturas_list: %Facturas.FacturasList{ id: mayor.id + 1, lista: lista}
    }

  end

  def save_csv( %FacturasFile{file: file, facturas_list: facturas}) do
    %Facturas.FacturasList{ id: _id, lista: lista} = facturas
    new_file = new_name_file(file)
    lista
      |>Enum.sort(&(&1.id <= &2.id))
      |>Enum.map(fn x -> File.write(
                   new_file,
                   "#{x.fecha}, #{x.id}, #{x.importe}, #{x.iva}, #{x.irpf}, #{x.pagada}, \"#{x.concepto}\"\n",
                   [:append]
                  )
                 end)
  end

  def new_name_file(_name) do
    fecha = DateTime.utc_now
    ext = "#{fecha.year}#{fecha.month}#{fecha.day}#{fecha.hour}#{fecha.minute}#{fecha.second}"
    # String.slice(name, 0..-4)<>"#{ext}.csv"
    "facturas."<>"#{ext}.csv"
  end

end
