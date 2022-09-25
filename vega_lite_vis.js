var vg_1 = "JSON/refugees_yearly.json";
vegaEmbed("#countryOfAsylum", vg_1)
    .then(function(result) {
        // Access the Vega view instance (https: //vega.github.io/vega/docs/api/view/) as result.view
    })
    .catch(console.error);