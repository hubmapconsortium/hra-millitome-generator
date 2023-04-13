# CCF-GTEx Pilot
## NIH Title: FAIR API

## Primary Deliverables

Test EUI to visualize RUI location data that is exported from Cinema 4D

* CCF API
  * Production: <https://ccf-api.hubmapconsortium.org>
  * Staging: <https://ccf-api--staging.herokuapp.com>
  * OpenAPI Specification: [ccf-api-spec.yaml](https://ccf-api.hubmapconsortium.org/ccf-api-spec.yaml)
* CCF API Client Libraries:
  * JavaScript: ![npm (scoped)](https://img.shields.io/npm/v/@ccf-openapi/js-client)  [@ccf-openapi/js-client](https://www.npmjs.com/package/@ccf-openapi/js-client)
  * TypeScript: ![npm (scoped)](https://img.shields.io/npm/v/@ccf-openapi/ts-client)  [@ccf-openapi/ts-client](https://www.npmjs.com/package/@ccf-openapi/ts-client)
  * Angular 12+: ![npm (scoped)](https://img.shields.io/npm/v/@ccf-openapi/ng-client) [@ccf-openapi/ng-client](https://www.npmjs.com/package/@ccf-openapi/ng-client)
  * Python 3.6+: ![PyPI](https://img.shields.io/pypi/v/ccf-openapi) [ccf-openapi](https://pypi.org/project/ccf-openapi/)

* [CCF-API implementation in the HuBMAP cloud](https://ccf-api.hubmapconsortium.org) ([source code](https://github.com/hubmapconsortium/ccf-ui))
* [GTEx data registered via the CCF RUI](https://hubmapconsortium.github.io/ccf-gtex-pilot/ccf-eui.html)
* [HuBMAP and GTEx tissue comparison by organ](https://hubmapconsortium.github.io/ccf-gtex-pilot/ccf-organs.html)
* [GTEx data in the HuBMAP cloud](https://portal.hubmapconsortium.org/ccf-eui)
* [GTEx and HuBMAP data in the GTEx cloud](https://gtexportal.org/home/eui)
* [ASCT+B / Anatogram Data Dashboard](https://hubmapconsortium.github.io/ccf-gtex-pilot/dashboard.html)
* [Video Tutorial](https://youtu.be/CWCGORb2zZ4)

## Deliverables by Milestone

| Deliverable or Milestone | Due Date | Status | Links
|---|:-:|:-:|---|
| 1.2.1.1 Develop an OpenAPI specification (CCF-API) to be implemented on both HuBMAP and GTEx clouds for data interoperability when used from HuBMAP Exploration User Interface (EUI) or other compatible CCF-API clients (Joint) | 12/21/2022 | Complete | [spec](https://ccf-api.hubmapconsortium.org/ccf-api-spec.yaml) 
| 1.2.1.2 Extend CCF to capture Anatomical Structures, Cell Types, plus Biomarkers (ASCT+B) information in GTEx anatomogram data (IU) | 12/31/2022 | Complete | [dashboard](https://hubmapconsortium.github.io/ccf-gtex-pilot/dashboard.html)
| 1.2.1.3 Spatially register GTEx tissue samples that currently overlap with HuBMAP using the CCF Registration User Interface (RUI) (Joint) | 12/31/2022 | Complete | [demo1](https://hubmapconsortium.github.io/ccf-gtex-pilot/ccf-eui.html) [demo2](https://hubmapconsortium.github.io/ccf-gtex-pilot/ccf-organs.html) [production](https://gtexportal.org/home/eui)
| 1.2.2.1 Implement and deploy the FAIR CCF-API for HuBMAP data in the HuBMAP cloud (IU) | 12/31/2022 | Complete | [live API](https://ccf-api.hubmapconsortium.org) [code](https://github.com/hubmapconsortium/ccf-ui/tree/main/projects/ccf-api)
| 1.2.2.2 Validate CCF ASCT+B tables using GTEx RNA and snRNAseq data and revising the tables as needed (Joint) | 3/31/2022 | Complete |
| 1.2.3.1 Implement CCF-API client libraries in Python and JavaScript for use in most cloud workspaces (IU) | 3/31/2022 | Complete | [See above](#primary-deliverables)
| 1.2.3.2 Deploy EUI as a web component compatible with most cloud workspaces (IU) | 3/31/2022 | Complete | [demo](https://hubmapconsortium.github.io/ccf-gtex-pilot/ccf-eui.html) [gtex portal](https://gtexportal.org/home/eui)
| 1.2.3.3 Demonstrate cross-search capabilities for ASCT+B data in support of increased interoperability of GTEx and HuBMAP data (GTEx) | 3/31/2022 | Complete | [demo](https://portal.hubmapconsortium.org/ccf-eui)
| 1.2.4.1 Publish documentation for the CCF-API, data querying from cloud workspaces, and EUI integration into portals/cloud workspaces (IU) | 6/30/2022 | Complete | [API docs](https://ccf-api.hubmapconsortium.org/)
| 1.2.4.2 Develop a video tutorial and training module to be hosted on the GTEx portal to help users find and interact with the data on the HuBMAP EUI and for inclusion in an online course (Joint) | 6/30/2022 | Complete | [video](https://youtu.be/CWCGORb2zZ4)
