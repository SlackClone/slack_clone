json.array! @users do |user|
  json.id "@"+user.nickname
  json.name user.profile&.full_name
end