$(document).ready ->
  window.visualSearch = VS.init
    container  : $('#apartment_search_box_container'),
    query      : 'city: "Tel Aviv" rooms: 1.5 "min price": 4000 "max price": 6000',
    showFacets : true,
    unquotable : ['text'],
    callbacks  :
      search: (query, searchCollection) ->
        $query = $('#apartment_search_query')
        $query.stop().animate({opacity : 1}, {duration: 300, queue: false})
        $query.html('<span class="raquo">&raquo;</span> You searched for: <b>' + searchCollection.serialize() + '</b>')
        clearTimeout(window.queryHideDelay)
        window.queryHideDelay = setTimeout ->
          $query.animate({opacity : 0}, {duration: 2000, queue: false})
        , 5000

        params =
          type: "POST",
          url: "/search",
          data: "json=#{JSON.stringify(visualSearch.searchQuery.facets())}",
          dataType: "json"

        $.ajax(params).success (data)->
          $query.html JSON.stringify(data)

      valueMatches: (category, searchTerm, callback) ->
        switch category
          when 'city'
            callback ['Jerusalem', 'Tel Aviv', 'Haifa', 'Ashdod', 'Herzliya']
          when 'rooms'
            callback ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", ">5"]

      facetMatches: (callback) ->
        callback ['city', 'rooms', 'min price', 'max price']
