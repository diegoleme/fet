require 'i18n'
require 'date'

def toURL string
  I18n.enforce_available_locales = false
  I18n.transliterate(string).downcase.gsub(/\s/,"-").gsub(/&/,"e")
end

def date_format d
 	date = DateTime.parse d.to_s
	date.strftime "%d/%m/%Y"
end

def post id
  @items.each do |item|
    if item.identifier.index id.to_s
      # return item[:url] + ' "' + item[:title] + '"'
      return item[:url]
    end
  end
end

def items_with(key, value)
  @items.select { |i| (i[key] || []).include?(value) }
end
