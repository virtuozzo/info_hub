module Filterable
  def filter(filtering_params)
    results = is_a?(Class) ? all : self

    filtering_params.inject(results) do |results, (key, value)|
      # key can be passed with _id at the end or without
      # e.g.: filter_field or filter_field_id calls by_filter_field scope
      value.present? ? results.public_send("by_#{key.sub(/_id\z/, '')}", value) : results
    end
  end
end
