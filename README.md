# Argo Workflow + dbt Proof of Concept

This repositoy contains examples of the use of Argo Workflow and dbt.
Examples:
- [ELT workflow]()
- [ELT + dbt]()

## Pre-requisits

In order to run locally the examples you have to install:
- [Docker]()
- [Kind]()
- [Argo Workflow]()
- [k9s]() (optional)

## Example: ELT workflow

### Project Structure

Project defined under [elt_workflow]() folder.


- `.argo/`: (Optional) Argo CLI configuration.
- `workflows/`: Argo Workflow YAML files.
  - `extract/`: Data extraction template.
  - `load/`: Data loading template.
  - `transform/`: Data transformation template.
  - `main_elt_workflow.yaml`: Main workflow definition.
- `scripts/`: Transformation scripts.
  - `transform/`: Scripts for the transformation stage.
    - `Dockerfile`: file to wrap transformation script.
    - `requirements.txt`: Python dependencies.

### Cons

I found some cons creating this examples:

- You can't use argument artifacts in dag tasks. Instead using sequential executions you can.
