class GoogleScraper
  def categories(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    doc = Nokogiri::HTML(response)
    categories = doc.search('.s9').children[0..-3].map(&:text)
    filter_categories(categories)
  end

  private

  def filter_categories(categories)
    categories.map do |category|
      if category == 'Bar'
        category
      else
        split_category = category.split(' ')
        split_category.first if split_category.last == 'Restaurant'
      end
    end.compact
  end
end
