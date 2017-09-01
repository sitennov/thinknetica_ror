class Search < ApplicationRecord
  SEARCH_LIST = %w(Questions Answers Comments Users)

  def self.search_result(query, search_area)
    query_escape = ThinkingSphinx::Query.escape(query)

    if SEARCH_LIST.include?(search_area)
      search_area.singularize.classify.constantize.search query_escape
    else
      ThinkingSphinx.search query_escape
    end
  end
end

# Article.search ThinkingSphinx::Query.escape(params[:query])
