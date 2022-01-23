module ApiCommons
  def api_data_load(root_key, profiles)
    data = API_DATA_FILE
    profile_array = profiles.split
    obj = data[root_key]&.select { |item| profile_array&.all? { |element| item['profiles']&.include?(element) } }&.sample
    JSON.parse obj.to_json, object_class: OpenStruct
  end

  def get_base_url(api_name)
    URL_CONFIG['urls'][api_name]
  end
end
