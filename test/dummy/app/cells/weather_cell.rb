class WeatherCell < Cell::Base
  def show(params)
    @city = params[:city]
    @area = params[:area]
    render
  end
end

