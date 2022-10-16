var countryAsylum = "JSON/asylum_refugees.json";
var continentRanking = "JSON/reject_ranking.json";
var grantedProtect = "JSON/refugee_protect.json";
var dpTypes = "JSON/DP_types.json";
var mgDeaths = "JSON/migrant_deaths.json";
var afgIncome = "JSON/afghanistan_income_move.json";
var syrIncome = "JSON/syria_income_move.json";
var myrIncome = "JSON/myanmar_income_move.json";
var venIncome = "JSON/venezuela_income_move.json";
var sudIncome = "JSON/sudan_income_move.json";

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

vegaEmbed("#afgIncome", afgIncome)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#syrIncome", syrIncome)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#myrIncome", myrIncome)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#venIncome", venIncome)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);

vegaEmbed("#sudIncome", sudIncome)
  .then(function (result) {
    // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
  })
  .catch(console.error);
