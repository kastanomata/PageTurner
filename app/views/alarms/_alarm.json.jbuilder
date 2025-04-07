json.extract! alarm, :id, :user_id, :alarm_id, :alarm_type, :created_at, :updated_at
json.url alarm_url(alarm, format: :json)
