var vg_1 = "JSON/asylum_refugees.json";
var vg_2 = "JSON/rejection_ranking.JSON";
vegaEmbed("#countryOfAsylum", vg_1)
    .then(function(result) {
        // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
    })
    .catch(console.error);

vegaEmbed("#rejectRank", vg_2)
    .then(function(result) {
        // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
    })
    .catch(console.error);