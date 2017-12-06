def self.search(params)
  query = Book.eager_load(:authors, :locations, shelves: :hall)
  params.each do |entity, hsh|
    hsh.each do |atr, val|
      next if val.nil? || val.to_s.blank?
      query = query.where( entity.pluralize.to_sym => {atr => val} )
    end
  end
  return query
end
