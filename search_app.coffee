class Map
  API_KEY = "947e1d95ed0144569fb1066e9e900d8b"

  constructor: (@lat, @long, @zoom) ->
    @map = L.map('map').setView([@lat, @long], @zoom)
    L.tileLayer("http://{s}.tile.cloudmade.com/#{API_KEY}/997/256/{z}/{x}/{y}.png", {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
    }).addTo(@map);
    @markers = []

  panTo: (lat, long) -> @map.panTo [lat, long]
  popup: (lat, long, text) ->
    @markers.push marker = L.marker([lat, long])
    marker.addTo(@map).bindPopup(text)
  clear: -> @map.removeLayer marker while marker = @markers.shift()


SearchResults = Backbone.Model.extend
  output: $('#apartment_search_results')
  render: ->
    @output.empty()
    window.map.clear()

    assets = _.pluck @data, "real_estate"


    if (first = _.first(assets))?
      window.map.panTo first.lat, first.long
    else
      @output.html "<div class='span4'><p>Sorry, no results for your query.</p></div>"

    _.each assets, (real_estate) =>
      area = "#{rooms = real_estate.rooms} #{if rooms == 1 then 'room' else 'rooms'}"

      partial =
        """
          <div class="span4 real_estate">
            <h4>#{real_estate.title} <small>for #{real_estate.price} NIS</small></h4>
            <p>#{area} at <em>#{real_estate.address}</em></p>
            <p>#{real_estate.description}</p>
            <p>Please call <strong>#{real_estate.owner}, #{real_estate.phone}</strong></p>
          </div>
        """
      @output.append partial

      popup =
        """
          <p>#{real_estate.address}<br/>#{area} at for <strong>#{real_estate.price} NIS</strong><br/>
          #{real_estate.owner}, #{real_estate.phone}

        """

      window.map.popup real_estate.lat, real_estate.long, popup

$(document).ready ->
  window.map = new Map(32.066667, 34.783333, 13) # Tel Aviv

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
            callback ['Jerusalem', 'Tel Aviv']
          when 'rooms'
            callback ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5"]

      facetMatches: (callback) ->
        callback ['city', 'rooms', 'min price', 'max price']

  searchCallback()
