json.tracks(@tracks) do |i|
  json.id i.id
  json.name i.name
  json.location i.location
  json.length_meters i.length_meters
  json.is_indoor i.is_indoor
  json.created_at i.created_at
  json.updated_at i.updated_at
end

json.meta do
  json.current_page @tracks.current_page
  json.total_pages @tracks.total_pages
  json.total_count @tracks.total_count
end