# Helm Styleguide

## Indentation

Indentation may be used if it helps with understanding the code. Use two spaces to indent. Beware of whitespacing.

## Documentation

In general, documentation and requirments for the scope when calling a template should be specified with a template comment.
In a `.yaml` file a template comment should be at the very beginning of the file, in a `.tpl` file there should be one before every line that contains a `define`keyword.
A short sentence describing the functionality of the template may be provided, but is not manditory.
In a `.yaml` file it should be assumed that the [Built-in Objects of Helm](https://helm.sh/docs/chart_template_guide/builtin_objects/) are provided in the scope, hence they don't need to be specified. In a `.tpl` file they should be documented.
To avoid nil-pointers, always specify up to the second to last layer of depth in the structure of the scope. If a parameter being nil leads to the output of the rendered template being empty at a point, the parameter should be specified as well.
Also `if`, `then` and `else` may be used.

Example:

```
{{/*
Prints the name of the chart.

Requirements:
    .Values
    if .Values.nameOverride then .Chart.Version
    else .name
*/}}
{{- define "this_chart.name" -}}
  {{- if .Values.nameOverride -}}
    {{- printf "%s-%s" .Values.nameOverride .Chart.Version }}
  {{- else -}}
    {{- .name -}}
  {{- end -}}
{{- end -}}
```