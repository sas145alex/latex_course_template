class Author < ActiveRecord::Base
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books

  validates :author_index, :fn, :ln, presence: true
  validates :author_index, length: { minimum: 2 }, allow_blank: true
  validates :author_index, uniqueness: { scope: :ln, message: "уже есть у одного из авторов-софамильцев"}

  def name_with_initial
    "#{fn.first}. #{ln}"
  end

  def self.attributes_names
    self.new.attributes.keys - ['created_at', 'updated_at']
  end
end

class Book < ActiveRecord::Base
  has_many :author_books, dependent: :destroy
    accepts_nested_attributes_for :author_books,
    reject_if: :all_blank, allow_destroy: true
  has_many :authors, through: :author_books
  has_many :locations, dependent: :destroy
  has_many :shelves, through: :locations
    accepts_nested_attributes_for :locations, allow_destroy: true,
      reject_if: proc { |attributes| attributes[:rack_number].blank? }

  validates :name, :isbn, presence: true
  validates :quantity, numericality: { only_integer: true,
    greater_than_or_equal_to: 0, message: "должно быть не отрицательным" }
  validates :volume, numericality: { only_integer: true, greater_than: 0,
    message: "должно быть больше нуля"}, allow_blank: true
  validates :isbn, uniqueness: true

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

  def self.attributes_names
    self.new.attributes.keys - ['created_at', 'updated_at']
  end
end

class Hall < ActiveRecord::Base
  has_many :shelves, dependent: :destroy

  validates :short_name, :full_name, presence: true
  validates :short_name, uniqueness: true

  def self.attributes_names
    self.new.attributes.keys - ['created_at', 'updated_at']
  end
end

class Shelf < ActiveRecord::Base
  belongs_to :hall
  accepts_nested_attributes_for :hall
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations
  has_many :books, through: :locations

  validates :hall, :shelf_index, presence: true
  validates :shelf_index, length: { minimum: 2 }
  validates :shelf_index, uniqueness: true

  def self.attributes_names
    self.new.attributes.keys - ['created_at', 'updated_at']
  end
end

class Location < ActiveRecord::Base
  belongs_to :book
  belongs_to :shelf

  validates :rack_number, presence: true
  validates :rack_number, numericality: { only_integer: true,
    greater_than: 0, message: "должно быть положительным" }
  validates :rack_number, uniqueness: {
    scope: [:book_id, :shelf_id], message: "и остальные поля должны быть уникальными"}

  def self.attributes_names
    self.new.attributes.keys - ['created_at', 'updated_at']
  end
end

class AuthorBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :author
  accepts_nested_attributes_for :author

  validates :book_id, uniqueness: {
    scope: :author_id, message: "Эта книга и автор уже связаны" }
end
