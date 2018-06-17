require 'elasticsearch/model'


module Searchable
  extend ActiveSupport::Concern

  included  do
    include Elasticsearch::Model

    mapping do
      indexes :id, index: :not_analyzed
      indexes :name
      indexes :synopsis
      indexes :year
      indexes :language
      indexes :country
      indexes :runtime,      type: 'integer'
      indexes :review,       type: 'float'
      indexes :crews, type: 'nested' do
        indexes :id,   type: 'integer'
        indexes :name, type: 'string', index: :not_analyzed
      end
      indexes :genres, type: 'nested' do
        indexes :id,   type: 'integer'
        indexes :name, type: 'string', index: :not_analyzed
      end
    end

    def as_indexed_json(options = {})
      self.as_json(only: [:id, :name, :synopsis, :year, :country, :language, :runtime, :review],
                   include: {
                       crews:  { only: [:id, :name] },
                       genres: { only: [:id, :name] }
                   })
    end

    class << self
      def custom_search(query_segment)
        query_segment = { "keyword" => "Terminator", "crews" => "1,27", "genres" => "2332, 2323"}
        keyword         = query_segment.delete("keyword")
        filter_segments = query_segment

        __elasticsearch__.search(query:  MoviesQuery.build(keyword),
                                 # aggs:   MoviesQuery::Aggregate.build,
                                 filter: MoviesQuery::Filter.build(filter_segments))
      end
    end
  end
end