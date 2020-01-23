defmodule Facturas.Server do
  use GenServer

  ### GenServer API

  def start_link(file) do
    GenServer.start_link(__MODULE__, file, name: __MODULE__)
  end

  def init(file) do
    fact_file = Facturas.FacturasFile.load(file)
    %Facturas.FacturasFile{file: _, facturas_list: lista} = fact_file
    {:ok, lista}
  end

  def handle_call(:pagadas, _from, state) do
    {:reply, Facturas.FacturasList.pagadas(state), state}
  end

  def handle_call(:nopagadas, _from, state) do
    {:reply, Facturas.FacturasList.no_pagadas(state), state}
  end

  def handle_call(:total, _from, state) do
    {:reply, Facturas.FacturasList.total(state), state}
  end
  
  def handle_call(:totalpagadas, _from, state) do
    {:reply, Facturas.FacturasList.total_pagadas(state), state}
  end

  def handle_call(:totalnopagadas, _from, state) do
    {:reply, Facturas.FacturasList.total_no_pagadas(state), state}
  end

  def handle_call(:count, _from, state) do
    {:reply, Facturas.FacturasList.count(state), state}
  end

  def handle_call({:year, year}, _from, state) do
    {:reply, Facturas.FacturasList.year(state, year), state}
  end

  ### Client API

  def pagadas,        do: GenServer.call(__MODULE__, :pagadas)
  def nopagadas,      do: GenServer.call(__MODULE__, :nopagadas)
  def total,          do: GenServer.call(__MODULE__, :total)
  def totalpagadas,   do: GenServer.call(__MODULE__, :totalpagadas)
  def totalnopagadas, do: GenServer.call(__MODULE__, :totalnopagadas)
  def count,          do: GenServer.call(__MODULE__, :count)
  def year(year),     do: GenServer.call(__MODULE__, {:year, year})
end
