#chart.coffee
(($) ->

  $.fn.Radarchart = (keywords, rates) ->
    data = {
      labels: keywords,
      datasets : [
        {
          label: "Base Data",
          fillColor: "rgba(255,255,255,0)",
          strokeColor: "rgba(255,255,255,0)",
          pointColor: "rgba(255,255,255,0)",
          pointStrokeColor: "rgba(255,255,255,0)",
          pointHighlightFill: "rgba(255,255,255,0)",
          pointHighlightStroke: "rgba(255,255,255,0)",
          data: [5, 5, 5, 5, 5]
        },
        {
          label: "My Keywords",
          fillColor: "rgba(151,187,205,0.2)",
          strokeColor: "rgba(151,187,205,1)",
          pointColor: "rgba(151,187,205,1)",
          pointStrokeColor: "#fff",
          pointHighlightFill: "#fff",
          pointHighlightStroke: "rgba(151,187,205,1)",
          data: rates
        }
      ]
    }
    options = {
      showTooltips: false
    }

    myRadarChart = new Chart($("#canvas").get(0).getContext("2d")).Radar(data, options)

  return
) jQuery
