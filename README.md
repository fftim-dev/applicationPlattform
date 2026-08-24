# Application Plattform

This project was developed as part of a Bachelor's thesis. It is an academic working prototype of a platform for handling applications to a Master's programme, based on a real-world university application process. The implementation represents the prototype developed for the thesis.

## Architecture

The repository contains an AL application for Microsoft Dynamics 365 Business Central and a Python web application that exchanges application data with Business Central through web services. Supporting BPMN, component, sequence, and data-model artefacts document the prototype's process and structure.

![Component overview](bc/models/component_en.png)

## Repository structure

```text
bc/       — Business Central AL application and related models
web/      — Flask web application and HTML templates
model/    — BPMN process model
```

## Technologies

- Microsoft Dynamics 365 Business Central and AL
- Python, Flask, and Requests
- HTML, Jinja templates, and Bootstrap
- BPMN, PlantUML, and DBML model files

## Public version

This repository contains the public portfolio version of the Bachelor's thesis prototype. Certain university-specific implementation details, including parts of the academic evaluation logic, have been intentionally omitted. The repository focuses on the technical design and implementation of the prototype rather than documenting the university's internal admissions process.

## Prototype note

This is an academic working prototype and was not designed or security-hardened for production use.

## Usage and copyright

The repository is published primarily so that the project can be reviewed as part of the author's portfolio. It is not presented as an open-source product.
