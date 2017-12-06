def search_params
  params.require(:search).permit(
    book:     Book.attributes_names.map(&:to_sym),
    author:   Author.attributes_names.map(&:to_sym),
    location: Location.attributes_names.map(&:to_sym),
    shelf:    Shelf.attributes_names.map(&:to_sym),
    hall:     Hall.attributes_names.map(&:to_sym) )
end
