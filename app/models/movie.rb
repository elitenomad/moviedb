class Movie < ApplicationRecord
  include Searchable

  # we don't need the line below because we're
  # implementing our own
  # include Elasticsearch::Model::Callbacks

  after_commit  :index_document,  on: [:create, :update]
  after_commit  :delete_document, on: :destroy

  def index_document
    IndexerJob.perform_later('index',  self.id)
  end

  def delete_document
    IndexerJob.perform_later('delete', self.id)
  end

  validates :name, uniqueness: true

	has_and_belongs_to_many :genres

  has_many :roles
  has_many :crews, through: :roles


  class RelationError < StandardError
    def initialize(msg = "That Relationship Type doesn't exist")
      super(msg)
    end
  end

  def add_many(type, data)
    if type.in? ['Genre', 'Crew']
      # movie.genres = [data]
      self.send("#{type.downcase.pluralize}=", data.map do |g|
        type.classify.constantize.where(name: g).first_or_create!
      end)
    else
      raise RelationError
    end
  end
end
