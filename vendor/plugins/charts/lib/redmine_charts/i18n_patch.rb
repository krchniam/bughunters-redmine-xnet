require 'gloc'

module ChartsI18nPatch

  def l(symbol, hash = {})
    translation = GLoc.l(symbol)
    hash.each do |key, value|
      translation = translation.gsub("{{#{key.to_s}}}", value.to_s)
    end
    translation
  end

end