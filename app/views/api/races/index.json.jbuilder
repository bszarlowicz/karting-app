json.track do
  json.id @track.id
  json.name @track.name
  json.location @track.location
  json.length_meters @track.length_meters
  json.is_indoor @track.is_indoor
end

json.races(@races) do |i|
  json.id i.id
  json.name i.name
  json.start_time i.start_time
  json.end_time i.end_time
  json.created_at i.created_at
  json.updated_at i.updated_at
end

json.meta do
  json.current_page @races.current_page
  json.total_pages @races.total_pages
  json.total_count @races.total_count
end