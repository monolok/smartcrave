json.array!(@subs) do |sub|
  json.extract! sub, :id, :name, :description
  json.url sub_url(sub, format: :json)
end
