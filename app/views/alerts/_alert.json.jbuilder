json.extract! alert, :id, :user_id, :category_id, :level, :intro, :content, :time_from, :time_for, :clients, :number, :status, :created_at, :updated_at
json.url alert_url(alert, format: :json)
