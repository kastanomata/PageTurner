json.extract! user, :id, :email, :nickname, :description, :birthday, :created_at, :updated_at
json.url user_url(user, format: :json)
