# Summary

This repo shows a potential bug when using live uploads in a form with JS events inside a LiveComponent.

Inside a LiveComponent, if instead of defining the form events in the standard way like so:
`<form id="test-upload-form" phx-change="validate-file" phx-submit="save-file" phx-target={@myself}>`

You try to use the new JS feature for pushing events, like so:
`<form id="test-upload-js-form" phx-change={JS.push("validate-file-js", target: @myself)} phx-submit={JS.push("save-file-js", target: @myself)}>`

The live upload will send the event to the parent LiveView instead of the LiveComponent, this works with regular forms.
Adding `phx-target={@myself}` fixes the issue, but seems redundant or confusing as we already specified the target inside the JS event.

## To reproduce

1. Download the dependencies - `mix deps.get`
2. Run the app - `iex -S mix phx.server`
3. Open up the page - http://localhost:4000/live-upload-test
4. Try uploading a file and check logs.

## Relevant files - modules

1. lib/playground_web/components/live_upload_component.ex - Playground.Components.LiveUploadComponent
