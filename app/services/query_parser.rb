class QueryParser
  def self.parse(string)
    string.strip.squeeze.gsub(' ', '+') if string
  end
end