Working on automation.

# Pipeline Structure

## pipelines

Pipeline execution YAML developed for a specific platform and use-case. 

## terraform

A makeup of projects and modules that get executed with the pipeline execution

## vars

Pre-defined variables for build execution.

## Playbooks

download-assets

Tasks:
- validate assets directory and permissions based on group vars designation
- download the SAS Orchestration CLI and Mirror Manager software
    - unpack the contents of both
- create the sas_viya_playbook
- start downloading the mirror
