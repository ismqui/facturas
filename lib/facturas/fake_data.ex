defmodule Facturas.FakeData do
  @moduledoc """
  Module that creates a csv file, list, ... using the Faker library
  to have random data. The format for the data would be:

    - 2018-12-19, 1, 2050.65, 21, 7, true, "Servicios informaticos"
    - 2018-12-20, 2, 1050.65, 21, 7, true, "Servicios Python"
    - 2018-12-21, 3, 2550.65, 21, 7, false, "Servicios Elixir"
  """

  alias Facturas.Factura
  alias Facturas.FacturasList

  def csv_file(val) when is_integer(val) and val > 0 do
    Enum.each(1..val, fn i ->
      fecha    = Faker.Date.backward(365)
      precio   = (Faker.Commerce.price * 100) |> Float.round(2)
      producto = Faker.Commerce.product_name
      pagado   = Enum.random([true, false])

      IO.puts("#{fecha}, #{i}, #{precio}, 21, 7, #{pagado}, \"#{producto}\"")
    end)
  end

  @doc """
  In case incorrect argument
  """
  def create_file(_val) do
    {:error, "argument must be integer > 0"}
  end
  
  def list(val) when is_integer(val) and val > 0 do
    facturas =
      Enum.into(1..val, [], fn i ->
        fecha    = Faker.Date.backward(365)
        precio   = (Faker.Commerce.price * 100) |> Float.round(2)
        producto = Faker.Commerce.product_name
        pagado   = Enum.random([true, false])

        Factura.crear(Date.to_iso8601(fecha), 1, precio, pagado, producto)
      end)

    FacturasList.new()
    |> FacturasList.add_entries(facturas)
  end

  def list(_val) do
    {:error, "argument must be integer > 0"}
  end

end
