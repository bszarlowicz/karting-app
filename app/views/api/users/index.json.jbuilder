json.users(@users) do |i|
  json.id i.id
  json.email i.email
  json.created_at i.created_at
end

json.meta do
  json.current_page @users.current_page
  json.total_pages @users.total_pages
  json.total_count @users.total_count
end