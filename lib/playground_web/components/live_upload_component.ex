defmodule PlaygroundWeb.Components.LiveUploadComponent do
  use PlaygroundWeb, :live_component

  alias Phoenix.LiveView.JS

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:test, accept: :any)
     |> allow_upload(:test_js, accept: :any)}
  end

  def render(assigns) do
    ~H"""
    <div>
      Basic form (works!)
      <.form
        let={f}
        for={:test}
        id="test-basic-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <label>
          Name: <%= text_input f, :name %>
        </label>

        <%= submit "Submit" %>
      </.form>

      Form using JS event (works!)
      <.form
        let={f}
        for={:test}
        id="test-js-form"
        phx-submit={JS.push("save", target: @myself)}
      >
        <label>
          Name: <%= text_input f, :name %>
        </label>

        <%= submit "Submit" %>
      </.form>

      Basic live file upload (works!)
      <form id="test-upload-form" phx-change="validate-file" phx-submit="save-file" phx-target={@myself}>
        <%= live_file_input(@uploads.test) %>
        <%= for entry <- @uploads.test.entries do %>
          <span><%= entry.client_name %></span>
          <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>
        <% end %>

        <%= submit "Submit" %>
      </form>

      Live file upload with JS (only works if we add phx-target={@myself} to the form)
      <form id="test-upload-js-form" phx-change={JS.push("validate-file-js", target: @myself)} phx-submit={JS.push("save-file-js", target: @myself)}>
        <%= live_file_input(@uploads.test_js) %>
        <%= for entry <- @uploads.test_js.entries do %>
          <span><%= entry.client_name %></span>
          <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>
        <% end %>

        <%= submit "Submit" %>
      </form>
    </div>
    """
  end

  def handle_event("save", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_event("validate-file", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save-file", _, socket) do
    files =
      consume_uploaded_entries(socket, :test, fn %{path: path}, _entry ->
        {:ok, File.read!(path)}
      end)

    IO.inspect(files, label: "Uploaded files")

    {:noreply, socket}
  end

  def handle_event("validate-file-js", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save-file-js", _, socket) do
    files =
      consume_uploaded_entries(socket, :test_js, fn %{path: path}, _entry ->
        {:ok, File.read!(path)}
      end)

    IO.inspect(files, label: "Uploaded files")

    {:noreply, socket}
  end
end
