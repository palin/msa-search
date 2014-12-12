json.results do
  if @results.present?
    json.english @results.english, :title, :url if @results.english.present?
    json.welsh @results.welsh, :title, :url if @results.welsh.present?
  end
end