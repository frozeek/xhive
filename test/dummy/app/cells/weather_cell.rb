class WeatherCell < Cell::Rails
  def show(params)
    @city = params[:city]
    @area = params[:area]
    render
  end
end

