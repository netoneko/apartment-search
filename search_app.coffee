$(document).ready ->
  SearchResults = Backbone.Collection.extend
    output: $('#apartment_search_results')
    render: ->
      @output.empty()

      _.each @data, (item) =>
        real_estate = item["real_estate"]
        partial =
        """<li class="span4">
          <div class="thumbnail">
            <div class="caption">
              <h4>#{real_estate["title"]} <small>for #{real_estate["price"]} NIS</small></h4>
              <p>#{rooms = real_estate["rooms"]} #{if rooms == 1 then 'room' else 'rooms'} at <em>#{real_estate["address"]}</em></p>
              <p>#{real_estate["description"]}</p>
              <p>Please call <strong>#{real_estate["owner"]}, #{real_estate["phone"]}</strong></p>
            </div>
          </div>
          </li>"""
        @output.append partial


  window.searchResults = new SearchResults
  searchResults.bind 'refresh', -> @render()


  searchCallback = (query, searchCollection) ->
    params =
      type: "POST",
      url: "/search",
      data: "json=#{JSON.stringify(visualSearch.searchQuery.facets())}",
      dataType: "json"

    $.ajax(params).success (data)->
      window.searchResults.data = data
      window.searchResults.trigger('refresh')


  window.visualSearch = VS.init
    container  : $('#apartment_search_box_container'),
    query      : 'city: "Tel Aviv" "min price": 3000 "max price": 6000', #rooms: 1.5
    showFacets : true,
    unquotable : ['text'],
    callbacks  :
      search: searchCallback

      valueMatches: (category, searchTerm, callback) ->
        switch category
          when 'city'
            callback ['Jerusalem', 'Tel Aviv', 'Haifa', 'Ashdod', 'Herzliya']
          when 'rooms'
            callback ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", ">5"]

      facetMatches: (callback) ->
        callback ['city', 'rooms', 'min price', 'max price']

  searchCallback()
