json.users(@users) do |i|
  json.id i.id
  json.email i.email
  json.first_name i.first_name
  json.last_name i.last_name
  json.birthdate i.birthdate
  json.role_mask i.role_mask
  json.created_at i.created_at
end

json.meta do
  json.current_page @users.current_page
  json.total_pages @users.total_pages
  json.total_count @users.total_count
end