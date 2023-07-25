class SearchService
  RESOURCES = %w[All Question Answer Comment User].freeze

  def initialize(resource, query)
    @resource = resource
    @query = ThinkingSphinx::Query.escape(query)
  end

  def call
    @resource == 'All' ? ThinkingSphinx.search(@query) : @resource.constantize.search(@query)
  end
end
