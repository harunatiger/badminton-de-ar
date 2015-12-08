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
          fillColor: "rgba(23, 174, 223,0.2)",
          strokeColor: "rgba(23, 174, 223,1)",
          pointColor: "rgba(23, 174, 223,1)",
          pointStrokeColor: "#fff",
          pointHighlightFill: "#fff",
          pointHighlightStroke: "rgba(23, 174, 223,1)",
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
