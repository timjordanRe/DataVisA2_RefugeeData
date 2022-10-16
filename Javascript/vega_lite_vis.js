var countryAsylum = "JSON/asylum_refugees.json";
var continentRanking = "JSON/reject_ranking.json";
var grantedProtect = "JSON/refugee_protect.json";
var dpTypes = "JSON/DP_types.json";
var mgDeaths = "JSON/migrant_deaths.json";
var mostDisplaced = "JSON/most_displaced.json";

vegaEmbed("#countryAsylum", countryAsylum)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#continentRanking", continentRanking)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#grantedProtect", grantedProtect)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#dpTypes", dpTypes)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#mgDeaths", mgDeaths)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#mostDisplaced", mostDisplaced)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);
