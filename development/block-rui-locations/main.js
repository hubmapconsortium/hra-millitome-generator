/* jshint esversion: 6 */

function resultsAsDatasets(jsonData, asctbAPI) {
  const nodes = asctbAPI.data.nodes;
  const csvItems = [];
  jsonData.tissueInfo.forEach(tissueInfo => {
    const uberonId = tissueInfo.uberonId;
    const match = nodes.find(node => node.metadata.ontologyId === `UBERON:${uberonId}`);
    const csvItem = {
      "GTEx Ontology ID": `UBERON:${uberonId}`,
      "GTEx Tissue Site": tissueInfo.tissueSiteDetail || 'No matches',
      "Ontology term": match ? match.metadata.label : 'No matches',
      "ASCT+B Table": 'No matches'
    };
    if (match) {
      csvItems.push({ ...csvItem, "ASCT+B Table": nodes[1].name });
    } else {
      csvItems.push(csvItem);
    }
  });

  return { csvItems };
}

let table;
function downloadTable() {
  if (table) {
    table.download("csv", "data.csv");
  }
}

function getOrganUris(config) {
  const organUris = [];
  for (const organ of config.sheetDetails) {
    if (organ.version) {
      for (const version of organ.version) {
        let asctbAPIUri = `https://asctb-api.herokuapp.com/v2/${version.sheetId}/${version.gid}/graph?cache=true`;
        organUris.push(asctbAPIUri);
      }
    }
  }

  return organUris;
}

function matchingData(csvItems) {
  let matches = [];
  matches = csvItems.filter(item => item['ASCT+B Table'] !== 'No matches');
  return matches;
}

function unmatchingData(csvItems) {
  let unmatches = [];
  unmatches = csvItems.filter(item => item['ASCT+B Table'] === 'No matches');
  return unmatches;
}

function addMatches(result, matches) {
  const ontologyIds = matches.map(entry => entry['GTEx Ontology ID']);
  result = result.filter(item => !ontologyIds.includes(item['GTEx Ontology ID']));
  return result.concat(matches);
}

function main() {
  Promise.all([
    fetch("vis.vl.json").then((result) => result.json()),
    fetch('https://gtexportal.org/rest/v1/dataset/tissueInfo?datasetId=gtex_v8&format=json').then((result) => result.json()),
    fetch("sheet-config.json").then((result) => result.json()),
    fetch("versions.json").then((result) => result.json()),
  ]).then(([spec, jsonData, config, versions]) => {
    let organUris = getOrganUris(config);
    organUris = organUris.map(uri => fetch(uri).then((result) => result.json()))
    
    Promise.all(organUris).then((allSets) => {
      let result = [];
      let seen = new Set;
      for (const dataset of allSets) {
        const csvItems = resultsAsDatasets(jsonData, dataset, versions).csvItems;
        const matches = matchingData(csvItems);
        const unmatches = unmatchingData(csvItems);
        if (result.length === 0) {
          result = unmatches;
        }
        if (matches.length > 0) {
          const ontologyId = matches[0]['GTEx Ontology ID'];
          if (!seen.has(ontologyId)) {
            result = addMatches(result, matches);
            seen.add(ontologyId);
          }
        }
      }
      result.sort((a, b) => (a['ASCT+B Table'] === 'No matches') ? 1 : -1);
      return result;
    }).then((result) => {
      spec.datasets = {csvItems: result};
      table = new Tabulator("#table", {
        layout:"fitColumns",
        data: spec.datasets.csvItems,
        autoColumns: true
      });
      // Embed the graph data in the spec for ease of use from Vega Editor
      return vegaEmbed("#visualization", spec, { "renderer": "svg", "actions": true });
    }).then((results) => {
      console.log("Visualization successfully loaded");
    });
  })}
main();
