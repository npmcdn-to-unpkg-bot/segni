class OperasController < ApplicationController
  layout 'pages'
  def show
    @opera = Opera.find_by! id: params[:id], website: @website
    @title = @opera.name
  end
end