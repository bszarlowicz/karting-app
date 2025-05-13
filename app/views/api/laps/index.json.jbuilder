json.track do
  json.id @track.id
  json.name @track.name
  json.location @track.location
  json.length_meters @track.length_meters
  json.is_indoor @track.is_indoor
end

json.race do
  json.id @race.id
  json.name @race.name
  json.start_time @race.start_time
  json.end_time @race.end_time
end

json.laps(@laps) do |i|
  json.id i.id
  json.username i.user.name
  json.user_id i.user_id
  json.race_id i.race_id
  json.lap_number i.lap_number
  json.lap_time_seconds i.lap_time_seconds
  json.position i.position
  json.created_at i.created_at
  json.updated_at i.updated_at
end

json.meta do
  json.current_page @laps.current_page
  json.total_pages @laps.total_pages
  json.total_count @laps.total_count
end