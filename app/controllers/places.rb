get '/places' do
  @results = PlacesApiClient.new.find_places(
    '41.389261',
    '2.136956',
    1000,
    'food'
  )
  @results.to_s
end
