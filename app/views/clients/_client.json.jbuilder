json.extract! client, :id, :name, :person, :website, :email, :status, :access_token, :created_at, :updated_at
json.url client_url(client, format: :json)
