class StationsController < ApplicationController
  before_action :set_station, only: [:show]

  # GET /stations
  # GET /stations.json
  def index
    #consumer = CNEConsumer.new
    codes = station_params[:code].split(',')
    commune = Commune.all.where(code: codes)
    @stations = commune.nil? ? Array.new : Station.all.where(commune_id: commune.map{|c| c.id})
    #consumer.gas_stations_by_location(commune: codes)
    @empty = @stations.empty?
    rendered_stations = (render_to_string partial: 'index_partial', locals: { stations: @stations }).to_json
    respond_to do |format|
      format.html
      format.js {
        counter = 0
        @markers_hash = Gmaps4rails.build_markers(@stations) do |station, marker|
          marker.lat station.location.x
          marker.lng station.location.y
          marker.infowindow render_to_string(:partial => "infowindow", :locals => { :station => station})
          counter += 1
        end
        render 'index', locals: { rendered_stations: rendered_stations, markers_hash: @markers_hash, empty: @empty }}
      format.json
    end
  end

  # GET /stations/1
  # GET /stations/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_station
    @station = Station.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def station_params
    params.require('locations').permit('code')
  end
end
