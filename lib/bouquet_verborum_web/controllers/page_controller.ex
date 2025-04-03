defmodule BouquetVerborumWeb.PageController do
  use BouquetVerborumWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def team(conn, _params) do
    render(conn, :team)
  end

  def order(conn, _params) do
    render(conn, :order)
  end

  def contact(conn, _params) do
    render(conn, :contact)
  end

end
